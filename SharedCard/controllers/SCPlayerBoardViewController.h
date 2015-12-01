//
//  SCPlayerBoardViewController.h
//  SharedCard
//
//  Created by JessieYong on 15/11/30.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCPlayerBoardViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *player;
@property (strong, nonatomic) IBOutlet UILabel *currentPoints;
@property (strong, nonatomic) IBOutlet UIImageView *card1;
@property (strong, nonatomic) IBOutlet UIImageView *card2;
@property (strong, nonatomic) IBOutlet UIImageView *card3;
@property (strong, nonatomic) IBOutlet UIImageView *card4;
@property (strong, nonatomic) IBOutlet UIImageView *card5;
- (IBAction)YES_btn:(id)sender;
- (IBAction)NO_btn:(id)sender;

@end
