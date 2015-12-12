//
//  SCMCManager.h
//  SharedCard
//
//  Created by JessieYong on 15/11/25.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
//import SharedCardProject-Swift.h to refer to swift function
#import "SharedCardProject-Swift.h"

@protocol SCMCManagerDelegate <NSObject>
@optional
//player and ipad
- (void)refreshWithPlayer:(Player *)player;
//just ipad
- (void)refreshWithUserChoice:(BOOL)anotherCard;
//...more data transfer methods
- (void)enableUserChoice;
- (void)endGameWithDrawGame:(BOOL)drawGame winner:(Player *)winner;
@end

@interface SCMCManager : NSObject<MCSessionDelegate>

//@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, assign) id<SCMCManagerDelegate>delegate;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

+ (instancetype)shareInstance;

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;
-(void)sendData:(NSData *)data toPeer:(MCPeerID *)peerID error:(NSError *)error;

//for iPhone
-(void)setIpadCenterPeerID:(MCPeerID *)peerID;
-(void)sendData:(NSData *)data toIpadCenterError:(NSError *)error;

@end
