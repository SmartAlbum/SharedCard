//
//  SCGameBoard3ViewController.h
//  SharedCard
//
//  Created by Christina on 1/12/15.
//  Copyright © 2015 JessieYong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedCardProject-Swift.h"
@interface SCGameBoard3ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *gameButton;

@property (strong, nonatomic) IBOutlet UIImageView *player1;
@property (strong, nonatomic) IBOutlet UIImageView *player2;
@property (strong, nonatomic) IBOutlet UIImageView *player3;

- (IBAction)newGame:(id)sender;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *playercards1;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *playercards2;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *playercards3;



@property (strong, nonatomic) Player *cPlayer1;
@property (strong, nonatomic) Player *cPlayer2;
@property (strong, nonatomic) Player *cPlayer3;

@property (strong, nonatomic) IBOutlet UIImageView *hideCard1;
@property (strong, nonatomic) IBOutlet UIImageView *hideCard2;
@property (strong, nonatomic) IBOutlet UIImageView *hideCard3;

@end
