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

@interface SCGameBoardViewController ()<MCBrowserViewControllerDelegate, MCSessionDelegate>{
    SCMCManager *_mcManager;
}
@end

@implementation SCGameBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mcManager = [[SCMCManager alloc] init];
    [_mcManager setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [_mcManager advertiseSelf:YES];
    
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


#pragma mark - MCBrowserViewControllerDelegate methods
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:^{
    }];
}



- (IBAction)beginSearch:(id)sender {
    [_mcManager setupMCBrowser];
    [[_mcManager browser] setDelegate:self];
    [self presentViewController:[_mcManager browser] animated:YES completion:nil];
}

- (IBAction)sendData:(id)sender {
    NSError *error = nil;
    NSString *str = @"123";
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [_mcManager.session sendData:data toPeers:[_mcManager.session connectedPeers] withMode:MCSessionSendDataReliable error:&error];
}
@end
