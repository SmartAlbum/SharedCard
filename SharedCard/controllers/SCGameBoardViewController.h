//
//  SCGameBoardViewController.h
//  SharedCard
//
//  Created by JessieYong on 15/11/25.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedCardProject-Swift.h"
@interface SCGameBoardViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *gamebutton;
@property (strong, nonatomic) IBOutlet UIImageView *player1;
@property (strong, nonatomic) IBOutlet UIImageView *player2;
- (IBAction)newGame:(id)sender;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *playercards1;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *playercards2;
@property (strong, nonatomic) Player *_player1;
@property (strong, nonatomic) Player *_player2;
@property (strong, nonatomic) IBOutlet UIImageView *hideCard1;
@property (strong, nonatomic) IBOutlet UIImageView *hideCard2;
@end
