//
//  SCPlayerBoardViewController.m
//  SharedCard
//
//  Created by JessieYong on 15/11/30.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCPlayerBoardViewController.h"
#import "SCMCManager.h"
#import <AVFoundation/AVFoundation.h>
#import "SCMyResultController.h"
@import MultipeerConnectivity;

@interface SCPlayerBoardViewController ()<SCMCManagerDelegate, AVAudioPlayerDelegate>
@property (strong, nonatomic) Player *playerSelf;
@property (nonatomic, strong) AVAudioPlayer *getCardPlayer;
@property (nonatomic, strong) AVAudioPlayer *gameStartPlayer;


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
    yes_button.enabled = FALSE;
    no_button.enabled = FALSE;
    NSError *error;
    NSString *readyMsg = @"ready";
    NSData *data = [readyMsg dataUsingEncoding:NSUTF8StringEncoding];
    [[SCMCManager shareInstance] sendData:data toIpadCenterError:error];
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"getCard" ofType:@"wav"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _getCardPlayer = audioPlayer;
    // 创建播放器
    _getCardPlayer.delegate = self;
    [_getCardPlayer setVolume:1];
    _getCardPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [SCMCManager shareInstance].delegate = self;
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
        no_button.enabled = false;
    }
    [_getCardPlayer prepareToPlay];
    [_getCardPlayer play]; //播放
}

- (IBAction)NO_btn:(id)sender {
    if (_playerSelf) {
        NSError *error;
        NSString *boolStr = [NSString stringWithFormat:@"%d", NO];
        NSData *data = [boolStr dataUsingEncoding:NSUTF8StringEncoding];
        [[SCMCManager shareInstance] sendData:data toIpadCenterError:error];
        //在不拿牌的时候都disable
        yes_button.enabled = false;
        no_button.enabled = false;
    }
}


- (void)refreshWithPlayer:(Player *)refreshPlayer {
    if (_playerSelf == nil && refreshPlayer != nil ) {
        NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"gameStart:Over" ofType:@"wav"];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
        AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _gameStartPlayer = audioPlayer;
        // 创建播放器
        _gameStartPlayer.delegate = self;
        [_gameStartPlayer setVolume:1];
        [_gameStartPlayer prepareToPlay];
        _gameStartPlayer.numberOfLoops = 1; //设置音乐播放次数  -1为一直循环
        [_gameStartPlayer prepareToPlay];
        [_gameStartPlayer play];
    }
    _playerSelf = refreshPlayer;
   //绘制界面
    Card *hiddenCard = refreshPlayer.hideCard;
    NSArray *otherCards = refreshPlayer.cards;
    if (hiddenCard) {
        NSLog(@"player set hidden Card");
        [hideCard setImage:[UIImage imageNamed: hiddenCard.imageName]];
    }
    for(UIImageView *playerCard in playercards){
            playerCard.image = nil;
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
    yes_button.highlighted = YES;
    no_button.enabled = true;
    no_button.highlighted = YES;
    NSLog(@"player enable button");
}

- (void)endGameWithException {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)endGameWithResult:(NSString *)result {
    NSLog(@"endGameEndGame");
    NSLog(@"--------getMessagePlayer:%@, result:%@\n\n", _playerSelf.Name, result);
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];
    SCMyResultController *resultController = [storyboard instantiateViewControllerWithIdentifier:@"resultController"];
    resultController.result = result;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:resultController animated:YES completion:^{
        }];
    });
}

@end
