//
//  SCMCManager.m
//  SharedCard
//
//  Created by JessieYong on 15/11/25.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCMCManager.h"
#define ISIPAD ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

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

-(void)sendData:(NSData *)data toPeer:(MCPeerID *)peerID error:(NSError *)error{
    if ([_session.connectedPeers containsObject:peerID]) {
        [_session sendData:data toPeers:@[peerID] withMode:MCSessionSendDataReliable error:&error];
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


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
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


@end
