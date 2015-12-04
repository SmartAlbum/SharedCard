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
@synthesize hideCard;
@synthesize playercards;
@synthesize yes_button;
@synthesize no_button;

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
    [self addObserver];
    [[SCMCManager shareInstance] setDelegate:self];
    // Do any additional setup after loading the view.
    yes_button.enabled = false;
    no_button.enabled = false;
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
        yes_button.enabled = false;
    }
}

- (IBAction)NO_btn:(id)sender {
    if (_playerSelf) {
        NSError *error;
        NSString *boolStr = [NSString stringWithFormat:@"%d", NO];
        NSData *data = [boolStr dataUsingEncoding:NSUTF8StringEncoding];
        [[SCMCManager shareInstance] sendData:data toIpadCenterError:error];
        no_button.enabled = false;
    }
}


- (void)refreshWithPlayer:(Player *)refreshPlayer {
    _playerSelf = refreshPlayer;
   //绘制界面
    Card *hiddenCard = refreshPlayer.hideCard;
    NSArray *otherCards = refreshPlayer.cards;
    if (hiddenCard) {
        [hideCard setImage:[UIImage imageNamed: hiddenCard.imageName]];
    }
    for (int i = 0 ; i< otherCards.count;i++) {
        for(UIImageView *playerCard in playercards){
            if(playerCard.tag == i){
                [playerCard setImage:[UIImage imageNamed:[[otherCards objectAtIndex:i] imageName]]];
            }
        }
    }
    currentPoints.text = _playerSelf.cardValueStr;
}
- (void)enableUserChoice{
    yes_button.enabled = true;
    no_button.enabled = true;
}

@end
