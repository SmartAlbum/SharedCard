//
//  SCPlayerBoardViewController.h
//  SharedCard
//
//  Created by JessieYong on 15/11/30.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MCSession;
@class MCPeerID;

@interface SCPlayerBoardViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *player;
@property (strong, nonatomic) IBOutlet UILabel *currentPoints;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *playercards;
@property (strong, nonatomic) IBOutlet UIImageView *hideCard;
@property (strong, nonatomic) IBOutlet UIButton *yes_button;
@property (strong, nonatomic) IBOutlet UIButton *no_button;


- (IBAction)YES_btn:(id)sender;
- (IBAction)NO_btn:(id)sender;


@end
