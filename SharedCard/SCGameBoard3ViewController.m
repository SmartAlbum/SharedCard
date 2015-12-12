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
#import "UIView+Toast.h"
#import <AVFoundation/AVFoundation.h>


@import MultipeerConnectivity;



@interface SCGameBoard3ViewController ()<SCMCManagerDelegate, AVAudioPlayerDelegate>
@property(nonatomic, strong)Game *gameManager;
//@property(nonatomic, strong)NSMutableDictionary *playerAvatarDic;
@property(assign) NSInteger playerCount;
@property(nonatomic, strong)AVAudioPlayer *player;



@end

@implementation SCGameBoard3ViewController

@synthesize player1;
@synthesize player2;
@synthesize player3;

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _gameManager = [[Game alloc] init];
        _playerCount = 0;
        //        _playerAvatarDic = [NSMutableDictionary dictionary];
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
        player.Id = peerID;
        [_gameManager addPlayer:player];
        if (_playerCount == 0) {
            _cPlayer1 = player;
            dispatch_async(dispatch_get_main_queue(), ^{
                [player1 setHighlighted:YES];
            });
            //            [_playerAvatarDic setObject:[UIImage imageNamed:@"head_1_b"] forKey:player.Id];
        }
        else if (_playerCount == 1) {
            _cPlayer2 = player;
            //            [player2 setImage:[UIImage imageNamed:@"head_2_b"]];
            //            [_playerAvatarDic setObject:[UIImage imageNamed:@"head_2_b"] forKey:player.Id];
            dispatch_async(dispatch_get_main_queue(), ^{
                [player2 setHighlighted:YES];
            });
        }
        else if (_playerCount == 2) {
            _cPlayer3 = player;
            //            [player3 setImage:[UIImage imageNamed:@"head_3_b"]];
            //            [_playerAvatarDic setObject:[UIImage imageNamed:@"head_3_b"] forKey:player.Id];
            dispatch_async(dispatch_get_main_queue(), ^{
                [player3 setHighlighted:YES];
            });
        }
        _playerCount++;
        
        if(_playerCount ==3){
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.imageSize = CGSizeMake(400, 400);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view makeToast:nil duration:3 position:CSToastPositionCenter title:nil image:[UIImage imageNamed:@"start-game"] style:style completion:^(BOOL didTap) {
                }];
            });
            //    }
            
            [_gameManager startGame];
            
            for(Player *player in [_gameManager getAllPlayers]){
                [self refreshWithPlayer:player];
            }
            
            //tell iphone i am ipad.
            NSError *error = nil;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"ipad"];
            [[SCMCManager shareInstance] sendData:data toPeer:peerID error:error];
        }
        //tell iphone i am ipad.
        NSError *error = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"ipad"];
        [[SCMCManager shareInstance] sendData:data toPeer:peerID error:error];
    }
    
    if(state == MCSessionStateNotConnected) {
        Player *player = [_gameManager getPlayer:peerID];
        //         [_gameManager removePlayer:[NSString stringWithFormat:@"%@", [[UIDevice currentDevice] identifierForVendor]]];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops!" message:[NSString stringWithFormat:@"%@ is offline. Game is stop!", player.Name] preferredStyle:UIAlertControllerStyleAlert];
        NSError *error = nil;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"endGame"];
        for (Player *player in [[Game Instance] getAllPlayers]) {
            [[SCMCManager shareInstance] sendData:data toPeer:player.Id error:error];
        }

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  [self dismissViewControllerAnimated:YES completion:nil];
                                                                  [_gameManager removeAllPlayer];
                                                              }];
        [alertController addAction:defaultAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }
    /*
     
     UIImage *avatar = [_playerAvatarDic valueForKey:player.Id];
     //拿到原来的头像
     _playerCount--;
     
     }*/
}


- (void)refreshWithPlayer:(Player *)player {
    
    NSArray *targetCards;
    if(_cPlayer1.Id == player.Id){
        _cPlayer1 = player;
        targetCards = _playercards1;
    }
    else if(_cPlayer2.Id == player.Id){
        _cPlayer2 = player;
        targetCards = _playercards2;
    }
    else if(_cPlayer3.Id == player.Id){
        _cPlayer3 = player;
        targetCards = _playercards3;
    }
    if(targetCards){
        for (UIImageView *imageView in targetCards){
            imageView.image = nil;
        }
        for (int i=0; i < player.cards.count;i++) {
            for (UIImageView *imageView in targetCards) {
                if(imageView.tag==i){
                    Card *card = [player.cards objectAtIndex:i];
                    NSString *imageName = card.imageName;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage *image = [UIImage imageNamed: imageName];
                        [imageView setImage:image];
                    });
                }
            }
        }
    }
}


- (void)beginAdvertiseing {
    [[SCMCManager shareInstance] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[SCMCManager shareInstance] advertiseSelf:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self beginAdvertiseing];
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"bgMusic" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player = player;
    // 创建播放器
    [_player prepareToPlay];
    _player.delegate = self;
    [_player setVolume:1];
    _player.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    [_player play]; //播放

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newGame:(id)sender{
    [_gameManager startGame];
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"endGame"];
    //todo render ui here. e.g: show player cards.
    for (Player *player in [[Game Instance] getAllPlayers]) {
        player.ready = false;
        [[SCMCManager shareInstance] sendData:data toPeer:player.Id error:error];
    }
}

-(void)endGameWithDrawGame:(BOOL)drawGame winner:(Player *)winner {

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
