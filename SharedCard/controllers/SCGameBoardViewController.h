//
//  SCGameBoardViewController.h
//  SharedCard
//
//  Created by JessieYong on 15/11/25.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCGameBoardViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *beginSearchButton;
- (IBAction)beginSearch:(id)sender;

- (IBAction)sendData:(id)sender;

@end
