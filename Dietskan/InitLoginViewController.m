//
//  InitLoginViewController.m
//  Dietskan
//
//  Created by Zach Feingold on 5/20/16.
//  Copyright © 2016 DietSkan. All rights reserved.
//
#import "MainViewController.h"

#import "InitLoginViewController.h"


@interface InitLoginViewController ()

@end

@implementation InitLoginViewController

- (IBAction)loginButton:(UIButton *)sender {
    [self loginAction];
}

- (void) loginAction {
    NSString *passcode = [[NSUserDefaults standardUserDefaults] stringForKey:@"passcode"];
    if (passcode == nil) {
        NSLog(@"No passcode");
        passcode = @"123456";
        [[NSUserDefaults standardUserDefaults] setValue:passcode forKey:@"passcode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"passcode"]);
    }
    
    if ([self.passcodeTextField.text isEqualToString:passcode]){ //1{
        MainViewController *v = [[MainViewController alloc] initWithNibName:@"MainUIView" bundle:nil];
        [self presentViewController:v animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Incorrect password"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil,nil];
        [alert show];
    }
    self.passcodeTextField.text = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.passcodeTextField.text = @"";
    [self.passcodeTextField becomeFirstResponder];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self loginAction];
    return YES;
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
