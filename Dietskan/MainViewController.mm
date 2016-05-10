//
//  MainViewController.m
//  Dietskan
//
//  Created by Yingkai Wang on 5/9/16.
//  Copyright © 2016 Occipital. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "appDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (IBAction)scanClick:(UIButton *)sender {
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ViewController *v = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    [self presentViewController:v animated:YES completion:nil];
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
