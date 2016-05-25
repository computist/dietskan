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

#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

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
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
//    
//    ViewController *v = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
//    [self presentViewController:v animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
        ViewController *v = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
        v->scan_id = result;
        [self presentViewController:v animated:YES completion:nil];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
