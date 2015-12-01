//
//  SCWelcomeViewController.m
//  SharedCard
//
//  Created by JessieYong on 15/11/30.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCWelcomeViewController.h"
#import "SCMCManager.h"


@interface SCWelcomeViewController ()
@end

@implementation SCWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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



- (IBAction)beginAdvertiseing:(id)sender {
    [[SCMCManager shareInstance] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[SCMCManager shareInstance] advertiseSelf:YES];
}

@end
