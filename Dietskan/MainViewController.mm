//
//  MainViewController.m
//  Dietskan
//
//  Created by Yingkai Wang on 5/9/16.
//  Copyright © 2016 Occipital. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "DropBoxLoginViewController.h"
#import "HistoryUIViewController.h"
#import "ProfileViewController.h"
#import "appDelegate.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (IBAction)profileClick:(UIButton *)sender {
   ProfileViewController *v = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
   [self presentViewController:v animated:YES completion:nil];
}
- (IBAction)historyClick:(UIButton *)sender {
   HistoryUIViewController *v = [[HistoryUIViewController alloc] initWithNibName:@"HistoryUIViewController" bundle:nil];
   [self presentViewController:v animated:YES completion:nil];
}
- (IBAction)settingsClick:(UIButton *)sender {
   DropBoxLoginViewController *v = [[DropBoxLoginViewController alloc] initWithNibName:@"DropBoxLoginViewController" bundle:nil];
   [self presentViewController:v animated:YES completion:nil];
}

- (IBAction)scanClick:(UIButton *)sender {
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
