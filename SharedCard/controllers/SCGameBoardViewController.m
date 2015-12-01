//
//  SCGameBoardViewController.m
//  SharedCard
//
//  Created by JessieYong on 15/11/25.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCGameBoardViewController.h"
#import "SCMCManager.h"

@import MultipeerConnectivity;

@interface SCGameBoardViewController ()
@end

@implementation SCGameBoardViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    [self addObserver];
    return  self;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"SCMCDidChangeStateNotification"
                                               object:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [self removeObserver];
}

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
//TODO For Tina(这个时候有人加进来或者出去了)

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    _mcManager = [[SCMCManager alloc] init];
//    [_mcManager setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
//    [_mcManager advertiseSelf:YES];

//    MCBrowserViewController *browserVC = [[MCBrowserViewController alloc] initWithServiceType:@"testtest" session:_session];
//    browserVC.delegate = self;
//    [self presentViewController:browserVC animated:YES completion:NULL];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)sendData:(id)sender {
    NSError *error = nil;
    NSString *str = @"123";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    [[[SCMCManager shareInstance]  session] sendData:data toPeers:[_mcManager.session connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}
@end
