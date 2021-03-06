//
//  SCIpadDrawController.m
//  SharedCard
//
//  Created by JessieYong on 15/12/12.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCIpadDrawController.h"
#import "SCMCManager.h"

@interface SCIpadDrawController ()

@end

@implementation SCIpadDrawController

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

- (IBAction)playAgain:(id)sender {
    NSError *error = nil;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:@"endGame"];
    for (Player *player in [[Game Instance] getAllPlayers]) {
        [[SCMCManager shareInstance] sendData:data toPeer:player.Id error:error];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
