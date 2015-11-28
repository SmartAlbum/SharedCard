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
@interface SCMCManager : NSObject<MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCBrowserViewController *browser;
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;

-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;

@end
