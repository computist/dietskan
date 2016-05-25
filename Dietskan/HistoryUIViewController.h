//
//  HistoryUIViewController.h
//  Dietskan
//
//  Created by Zach Feingold on 5/15/16.
//  Copyright © 2016 DietSkan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "HistoryData.h"

@interface HistoryUIViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, DBRestClientDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DBRestClient *restClient;

@end
