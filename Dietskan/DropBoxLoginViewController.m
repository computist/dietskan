//
//  DropBoxLoginViewController.m
//  Dietskan
//
//  Created by Zach Feingold on 5/16/16.
//  Copyright © 2016 DietSkan. All rights reserved.
//

#import "DropBoxLoginViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "AppDelegate.h"

extern DropBoxLoginViewController *dropBoxLoginViewController;

@interface DropBoxLoginViewController ()

@end

@implementation DropBoxLoginViewController

//Link to DropBox account
- (IBAction)didPressLink:(UIButton *)sender {
   if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
   } else {
       [[DBSession sharedSession] unlinkAll];
       [_linkButton setTitle: @"Link" forState:normal];
   }
}

//Go back to the MainViewUI
- (IBAction)backClick:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dropBoxLoginViewController = self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[DBSession sharedSession] isLinked]) {
        [_linkButton setTitle: @"Unlink" forState:normal];
    } else {
        [_linkButton setTitle: @"Link" forState:normal];
    }
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
