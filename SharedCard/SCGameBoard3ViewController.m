//
//  SCGameBoard3ViewController.m
//  SharedCard
//
//  Created by Christina on 1/12/15.
//  Copyright © 2015 JessieYong. All rights reserved.
//

#import "SCGameBoard3ViewController.h"
#import "SCMCManager.h"
#import "SharedCardProject-Swift.h"
@import MultipeerConnectivity;



@interface SCGameBoard3ViewController ()
@property(nonatomic, strong)Game *gameManager;

@end

@implementation SCGameBoard3ViewController

@synthesize player1;
@synthesize player2;
@synthesize player3;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _gameManager = [[Game alloc] init];
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
    [[SCMCManager shareInstance] advertiseSelf:NO];
}

- (void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCPeerID *peerID = [[notification userInfo] objectForKey:@"peerID"];
    NSString *peerDisplayName = peerID.displayName;
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    NSLog(@"PEER STATUE CHANGE(From SCGameBoard3):%@ is %ld\n", peerDisplayName, (long)state);
    if(state == MCSessionStateConnected) {
        Player *player = [[Player alloc] init];
        player.Id = [NSString stringWithFormat:@"%@", [[UIDevice currentDevice] identifierForVendor]];
        [_gameManager addPlayer:player];
    }
    if(state == MCSessionStateNotConnected) {
        [_gameManager removePlayer:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] identifierForVendor]]];
    }
}

- (void)beginAdvertiseing {
    [[SCMCManager shareInstance] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[SCMCManager shareInstance] advertiseSelf:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self beginAdvertiseing];
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

@end
