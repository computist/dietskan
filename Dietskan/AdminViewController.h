//
//  AdminViewController.h
//  Dietskan
//
//  Created by dietskan on 5/29/16.
//  Copyright © 2016 DietSkan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *confirmNewPasswordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *newpasswordTextfield;

@end
