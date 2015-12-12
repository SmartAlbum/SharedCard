//
//  SCMCManager.m
//  SharedCard
//
//  Created by JessieYong on 15/11/25.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCMCManager.h"

#define ISIPAD ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

@interface SCMCManager()
@property(nonatomic, strong)MCPeerID *iPadPeerID;
@end

@implementation SCMCManager

+ (instancetype)shareInstance
{
    static SCMCManager *shareManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[SCMCManager alloc] init];
    });
    return shareManager;
}


-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName{
    MCPeerID *peerID = [[MCPeerID alloc] initWithDisplayName:displayName];
    if (_session && ISIPAD) {
        _session = [[MCSession alloc] initWithPeer:peerID];
        _session.delegate = self;
    }
    else if(!_session) {
        _session = [[MCSession alloc] initWithPeer:peerID];
        _session.delegate = self;
    }
}

-(void)setupMCBrowser {
    if (_session) {
        _browser = [[MCBrowserViewController alloc] initWithServiceType:@"card-files"session:_session];
        _browser.maximumNumberOfPeers = 1;
    }
}

-(void)advertiseSelf:(BOOL)shouldAdvertise{
    if (shouldAdvertise) {
        _advertiser = [[MCAdvertiserAssistant alloc] initWithServiceType:@"card-files"
                                                           discoveryInfo:nil
                                                                 session:_session];
        [_advertiser start];
    }
    else{
        [_advertiser stop];
        _advertiser = nil;
    }
}



-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state{
    NSDictionary *dict = @{@"peerID": peerID,
                           @"state" : [NSNumber numberWithInt:state]
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SCMCDidChangeStateNotification"
                                                        object:nil
                                                      userInfo:dict];
    //    if (!ISIPAD && state == MCSessionStateConnected) {
    //        _iPadPeerID = peerID;
    //    }
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    if (ISIPAD) {
        NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if([msg  isEqual:@"ready"]){
            Game *game = [Game Instance];
            [game playerReady:peerID];
            if([game ready]){
                for (Player *player in [game getAllPlayers]) {
                    NSError *error = nil;
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:player];
                    [[SCMCManager shareInstance] sendData:data toPeer:player.Id error:error];
                    
                    if (_delegate && [_delegate respondsToSelector:@selector(refreshWithPlayer:)]) {
                        [_delegate refreshWithPlayer:player];
                    }
                }
                
                //check if any player is still available for getting cards.
                if(game.currentTurn){
                    NSError *error = nil;
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"getCard"];
                    [[SCMCManager shareInstance] sendData:data toPeer:game.currentTurn.Id error:error];
                    NSLog(@"ask player to get card");
                }
            }
            
        }else{
            NSString *boolStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            BOOL anotherCard = [boolStr boolValue];
            Game *game = [Game Instance];
            if(game.currentTurn.Id == peerID){
                if (anotherCard == YES) {
                    //current user needs another card
                    Player *player = game.currentTurn;
                    [game getCard];
                    NSError *error = nil;
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:player];
                    [[SCMCManager shareInstance] sendData:data toPeer:player.Id error:error];
                    if (_delegate && [_delegate respondsToSelector:@selector(refreshWithPlayer:)]) {
                        [_delegate refreshWithPlayer:player];
                    }
                }
                else{
                    //不要牌了
                    [game stopGettingCard:game.currentTurn.Id];
                }
                if([game isGameEnd]){
                    [self iPadGameEnd];
                    NSLog(@"Game End");
                }
                else if(game.currentTurn){
                    NSError *error = nil;
                    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"getCard"];
                    [[SCMCManager shareInstance] sendData:data toPeer:game.currentTurn.Id error:error];
                }
            }
            else{
                //todo
                NSLog(@"exception occur");
            }
        }
        
    }
    else{
        NSObject *unarchiverObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([unarchiverObject isKindOfClass:[Player class]]){
            Player *player = (Player *)unarchiverObject;
            if (player != nil) {
                _player = player;
                if (_delegate && [_delegate respondsToSelector:@selector(refreshWithPlayer:)]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_delegate refreshWithPlayer:_player];
                    });
                }
            }
        }
        else if([unarchiverObject isKindOfClass:[NSString class]]){
            NSString *message = (NSString *)unarchiverObject;
            if([message  isEqual: @"getCard"]){
                if (_delegate && [_delegate respondsToSelector:@selector(enableUserChoice)]) {
                    [_delegate enableUserChoice];
                    NSLog(@"Receive get card message");
                }
                
            }
           else if([message  isEqual: @"ipad"]){
                _iPadPeerID = peerID;
            }
            else if([message  isEqual: @"endGame"]){
                //有人掉线
                if(self.delegate && [_delegate respondsToSelector:@selector(endGameWithException)]) {
                    [_delegate endGameWithException];
                }
            }
            else if([message  isEqual: @"WIN"] || [message  isEqual: @"LOSE"] || [message  isEqual: @"DRAW"]){
                //结束显示结局
                if(self.delegate && [_delegate respondsToSelector:@selector(endGameWithResult:)]) {
                    [_delegate endGameWithResult:message];
                }
            }
            
        }
    }
    NSLog(@"did reveiveData");
}

- (void)iPadGameEnd {
    bool flag = NO;
    for(Player *player in [[Game Instance] getAllPlayers]){
        //show result based on player.result
        NSLog(@"--------player:%@, result:%ld\n\n", player, (long)[player getResult]);
        if ([player getResult] == 1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(endGameWithDrawGame:winner:)]) {
                [self.delegate endGameWithDrawGame:NO winner:player];
            }
            flag = YES;
            NSError *error = nil;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"WIN"];
            [[SCMCManager shareInstance] sendData:data toPeer:player.Id error:error];
            
        }
        else if ([player getResult] == 0) {
            NSError *error = nil;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"LOSE"];
            [[SCMCManager shareInstance] sendData:data toPeer:player.Id error:error];
            
        }
        else if ([player getResult] == -1) {
            NSError *error = nil;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"DRAW"];
            [[SCMCManager shareInstance] sendData:data toPeer:player.Id error:error];
        }
    }
    if (flag == NO) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(endGameWithDrawGame:winner:)]) {
            [self.delegate endGameWithDrawGame:YES winner:nil];
        }
    }
    
}

-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
    NSLog(@"did reveiveData");
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error{
    NSLog(@"did reveiveData");
}


-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    NSLog(@"did reveiveData");
}


//for iPhone
-(void)setIpadCenterPeerID:(MCPeerID *)peerID {
    _iPadPeerID = peerID;
}


-(void)sendData:(NSData *)data toIpadCenterError:(NSError *)error {
    while(_iPadPeerID == nil){
        
    }
    [_session sendData:data toPeers:@[_iPadPeerID] withMode:MCSessionSendDataReliable error:&error];
}

//for iPad
-(void)sendData:(NSData *)data toPeer:(MCPeerID *)peerID error:(NSError *)error{
    if ([_session.connectedPeers containsObject:peerID]) {
        [_session sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:&error];
    }
}

@end
