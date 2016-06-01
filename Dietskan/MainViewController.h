//
//  MainViewController.h
//  Dietskan
//
//  Created by Yingkai Wang on 5/9/16.
//  Copyright © 2016 Occipital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderDelegate.h"
@class ViewController;
@interface MainViewController : UIViewController <QRCodeReaderDelegate>

@property (strong, nonatomic) ViewController *viewController;

@end
