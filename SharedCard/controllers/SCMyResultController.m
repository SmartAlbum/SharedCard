//
//  SCMyResultController.m
//  SharedCard
//
//  Created by JessieYong on 15/12/12.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCMyResultController.h"
#import "SCMCManager.h"



@interface SCMyResultController ()<SCMCManagerDelegate>

@end

@implementation SCMyResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SCMCManager shareInstance] setDelegate:self];
    if([_result isEqualToString:@"WIN"]) {
        [_resultImageView setImage:[UIImage imageNamed:@"U_Win"]];
    }
    else if([_result isEqualToString:@"LOSE"]) {
        [_resultImageView setImage: [UIImage imageNamed:@"U_Lose"]];
    }
    else if([_result isEqualToString:@"DRAW"]) {
        [_resultImageView setImage: [UIImage imageNamed:@"Draw_Game"]];
    }
    else {
        //error
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)endGameWithException {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            NSError *error;
            NSString *readyMsg = @"ready";
            NSData *data = [readyMsg dataUsingEncoding:NSUTF8StringEncoding];
            [[SCMCManager shareInstance] sendData:data toIpadCenterError:error];
        }];
    });
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
