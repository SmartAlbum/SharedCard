//
//  SCStarterViewController.m
//  SharedCard
//
//  Created by JessieYong on 15/11/30.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCStarterViewController.h"
#import "SCPlayerBoardViewController.h"
#import "SCMCManager.h"

@interface SCStarterViewController ()<MCBrowserViewControllerDelegate>
@property(nonatomic, strong) MCPeerID *peerID;
@property(nonatomic, assign) BOOL isConnected;
@end

@implementation SCStarterViewController


- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _isConnected = NO;
        _peerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
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

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    if (state == MCSessionStateConnected) {
        _isConnected = YES;
    }
    else if (state == MCSessionStateNotConnected){
        _isConnected = NO;
    }
    //TODO For Tina(这个时候有人加进来或者出去了)
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MCBrowserViewControllerDelegate methods
- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [browserViewController dismissViewControllerAnimated:NO completion:^{
        if (_isConnected) {
            NSString *storyboardName = @"iPhone";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
            UIViewController *con = [storyboard instantiateViewControllerWithIdentifier:@"playerboard"];
            [self presentViewController:con animated:NO completion:^{
            }];
        }
    }];
}



- (IBAction)beginSearch:(id)sender {
    [[SCMCManager shareInstance] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[SCMCManager shareInstance] setupMCBrowser];
    [[[SCMCManager shareInstance] browser] setDelegate:self];
    [self presentViewController:[[SCMCManager shareInstance] browser] animated:YES completion:nil];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
