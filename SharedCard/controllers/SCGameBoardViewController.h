//
//  SCGameBoardViewController.h
//  SharedCard
//
//  Created by JessieYong on 15/11/25.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGameBoardViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIImageView *player1;
@property (strong, nonatomic) IBOutlet UIImageView *player2;
@property (strong, nonatomic) IBOutlet UIButton *beginSearchButton;
@property (nonatomic, strong) IBOutletCollection(UIImageView) NSArray *playercards1;

- (IBAction)sendData:(id)sender;

@end
