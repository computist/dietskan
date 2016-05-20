//
//  ProfileViewController.m
//  Dietskan
//
//  Created by Zach Feingold on 5/20/16.
//  Copyright © 2016 DietSkan. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (IBAction)backClick:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

@end
