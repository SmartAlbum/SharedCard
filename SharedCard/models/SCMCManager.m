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
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    if (ISIPAD) {
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
            }
            else{
                //不要牌了
                [game stopGettingCard:game.currentTurn.Id];
            }
            
            //check if any player is still available for getting cards.
            if(game.currentTurn){
                NSError *error = nil;
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"getCard"];
                [[SCMCManager shareInstance] sendData:data toPeer:game.currentTurn.Id error:error];
            }
        }
        else{
            //todo
            printf("exception occur");
        }
    }
    else{
        NSObject *unarchiverObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if([unarchiverObject isKindOfClass:[Player class]]){
            Player *player = (Player *)unarchiverObject;
            if (player != nil) {
                _player = player;
                if (_delegate && [_delegate respondsToSelector:@selector(refreshWithPlayer:)]) {
                [_delegate refreshWithPlayer:_player];
                }
            }
        }
        else if([unarchiverObject isKindOfClass:[NSString class]]){
            NSString *message = (NSString *)unarchiverObject;
            if([message  isEqual: @"getCard"]){
                if (_delegate && [_delegate respondsToSelector:@selector(enableUserChoice)]) {
                    [_delegate enableUserChoice];
                }
            }
        }
    }
    NSLog(@"did reveiveData");
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
    [_session sendData:data toPeers:@[_iPadPeerID] withMode:MCSessionSendDataReliable error:&error];
}

//for iPad
-(void)sendData:(NSData *)data toPeer:(MCPeerID *)peerID error:(NSError *)error{
    if ([_session.connectedPeers containsObject:peerID]) {
        [_session sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:&error];
    }
}

@end
