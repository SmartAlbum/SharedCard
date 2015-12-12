//
//  SCMyResultController.h
//  SharedCard
//
//  Created by JessieYong on 15/12/12.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCMyResultController : UIViewController
@property(nonatomic, strong)NSString *result;
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;
- (IBAction)playAgain:(id)sender;
@end
