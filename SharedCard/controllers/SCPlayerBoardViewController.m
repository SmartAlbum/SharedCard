//
//  SCPlayerBoardViewController.m
//  SharedCard
//
//  Created by JessieYong on 15/11/30.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCPlayerBoardViewController.h"
#import "SCMCManager.h"
@import MultipeerConnectivity;

@interface SCPlayerBoardViewController ()<SCMCManagerDelegate>
@property (strong, nonatomic) Player *playerSelf;

@end

@implementation SCPlayerBoardViewController

@synthesize player;
@synthesize currentPoints;
@synthesize card1;
@synthesize card2;
@synthesize card3;
@synthesize card4;
@synthesize card5;

- (id)init {
    if (self=[super init]) {
    }
    [self addObserver];
    [SCMCManager shareInstance].delegate = self;
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
    NSLog(@"PEER STATUE CHANGE(From SCPlayerBoard):%@ is %ld\n", peerDisplayName, (long)state);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)YES_btn:(id)sender {
    if (_playerSelf) {
        NSError *error;
        NSString *boolStr = [NSString stringWithFormat:@"%d", YES];
        NSData *data = [boolStr dataUsingEncoding:NSUTF8StringEncoding];
        [[SCMCManager shareInstance] sendData:data toIpadCenterError:error];
    }
}

- (IBAction)NO_btn:(id)sender {
    if (_playerSelf) {
        NSError *error;
        NSString *boolStr = [NSString stringWithFormat:@"%d", NO];
        NSData *data = [boolStr dataUsingEncoding:NSUTF8StringEncoding];
        [[SCMCManager shareInstance] sendData:data toIpadCenterError:error];
    }
}


- (void)refreshWithPlayer:(Player *)player {
    _playerSelf = player;
   //绘制界面
    Card *hiddenCard = player.hideCard;
    NSArray *otherCards = player.cards;
    if (hiddenCard) {
    }
    for (Card *card in otherCards) {
    }
}

@end
