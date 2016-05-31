//
//  AdminViewController.m
//  Dietskan
//
//  Created by dietskan on 5/29/16.
//  Copyright © 2016 DietSkan. All rights reserved.
//

#import "AdminViewController.h"

@interface AdminViewController ()

@end

@implementation AdminViewController
- (IBAction)backClick:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) update {
    NSString *passcode = [[NSUserDefaults standardUserDefaults] stringForKey:@"passcode"];
    if (passcode == nil) {
        passcode = @"123456";
        [[NSUserDefaults standardUserDefaults] setValue:passcode forKey:@"passcode"];
    }
    if (![self.oldPasswordTextfield.text isEqualToString:passcode]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Incorrect password"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil,nil];
        [alert show];
    } else if (self.newpasswordTextfield.text.length < 6) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Password must be at least 6 characters."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil,nil];
        [alert show];
    } else if (![self.newpasswordTextfield.text isEqualToString:self.confirmNewPasswordTextfield.text]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"New password confirmation not match."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil,nil];
        [alert show];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:self.newpasswordTextfield.text forKey:@"passcode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"passcode"]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)updateClick:(UIButton *)sender {
    [self update];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    if ([self.oldPasswordTextfield isFirstResponder]) {
        [self.newpasswordTextfield becomeFirstResponder];
    } else if ([self.newpasswordTextfield isFirstResponder]) {
        [self.confirmNewPasswordTextfield becomeFirstResponder];
    } else if ([self.confirmNewPasswordTextfield isFirstResponder]) {
        [self update];
    }
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.oldPasswordTextfield becomeFirstResponder];
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
