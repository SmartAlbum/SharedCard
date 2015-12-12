//
//  SCIpadCongController.m
//  SharedCard
//
//  Created by JessieYong on 15/12/12.
//  Copyright © 2015年 JessieYong. All rights reserved.
//

#import "SCIpadCongController.h"

@interface SCIpadCongController ()

@end

@implementation SCIpadCongController


- (void)viewDidLoad {
    [super viewDidLoad];
    if (_winnerIcon) {
        [_winIcon setImage:_winnerIcon];
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playAgain:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
