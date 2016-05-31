//
//  HistoryUIViewController.m
//  Dietskan
//
//  Created by Zach Feingold on 5/15/16.
//  Copyright © 2016 DietSkan. All rights reserved.
//

#import "HistoryUIViewController.h"

@interface HistoryUIViewController ()

@end

@implementation HistoryUIViewController

NSMutableArray *tableData;
NSArray *profileColorThumbnails;

static NSString *cellIdentifier = @"historyTableCell";

- (IBAction)backClick:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendClick:(UIButton *)sender {
}
- (IBAction)removeClick:(UIButton *)sender {
    NSMutableIndexSet *deleteArray = [[NSMutableIndexSet alloc] init];
    
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i)
    {
        HistoryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (cell.checked) {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            NSDate *date = [dateFormat dateFromString:cell.dateTimeLabel.text];
            if (date == nil) {
                continue;
            }
            NSDateFormatter *formatter;
            NSString        *dateString;
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
            dateString = [formatter stringFromDate:date];
            if (dateString == nil){
                continue;
            }
            
            [self.restClient deletePath:[NSString stringWithFormat:@"/Scan/%@/Scan_%@_%@.zip", cell.scanIdLabel.text, cell.scanIdLabel.text, dateString]];
            [self.restClient deletePath:[NSString stringWithFormat:@"/Scan/%@/Preview_%@_%@.jpg", cell.scanIdLabel.text, cell.scanIdLabel.text, dateString]];
            [deleteArray addIndex:i];
        }
    }
    
    [tableData removeObjectsAtIndexes:deleteArray];
    [self.tableView reloadData];
    //
}

- (void)viewDidLoad {
   [super viewDidLoad];
   tableData = [NSMutableArray new];
   // Do any additional setup after loading the view from its nib.
   self.tableView.delegate = self;
   self.tableView.dataSource = self;
   self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
   self.restClient.delegate = self;
   
   UINib *cellNib = [UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil];
   [self.tableView registerNib:cellNib forCellReuseIdentifier: cellIdentifier];
   
    [tableData removeAllObjects];
   [self.restClient loadMetadata:@"/Scan"];
   
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
   if (metadata.isDirectory) {
      
      NSLog(@"Folder '%@' contains:", metadata.path);
      for (DBMetadata *file in metadata.contents) {
         if ([file isDirectory]) {
             [self.restClient loadMetadata:[NSString stringWithFormat:@"/Scan/%@", file.filename]];
         } else if ([file.filename hasSuffix:@".zip"]) {
             NSArray *chunks = [[file.filename stringByDeletingPathExtension] componentsSeparatedByString: @"_"];
             if (chunks.count == 8) {
                 HistoryData *hd = [HistoryData new];
                 hd.scan_id = chunks[1];
                 NSArray *arr = [NSArray arrayWithObjects:chunks[2], chunks[3], chunks[4], chunks[5], chunks[6], chunks[7], nil];
                 NSString *dateString = [arr componentsJoinedByString:@"_"];
                 
                 NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                 [dateFormat setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
                 hd.date = [dateFormat dateFromString:dateString];
                 
                 [tableData addObject:hd];
             }
         }
      }
      [self.tableView reloadData];
   }
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
   NSLog(@"Error loading metadata: %@", error);
   [tableData removeAllObjects];
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
   // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   profileColorThumbnails = [NSArray arrayWithObjects:@"BlueProfile.png", @"GreenProfile.png", @"RedProfile.png", @"YellowProfile.png",
                            @"CyanProfile.png", @"LimeProfile.png", @"OrangeProfile.png", @"GrayProfile.png", nil];
   HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
   
   HistoryData *hd = tableData[indexPath.row];
   NSDateFormatter *formatter;
   NSString        *dateString;
   formatter = [[NSDateFormatter alloc] init];
   [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
   dateString = [formatter stringFromDate:hd.date];
   
   NSString *HH = [dateString substringWithRange:NSMakeRange(11, 2)];
   if (HH.integerValue < 11) {
      cell.mealTypeLabel.text = @"Breakfast";
   } else if (HH.integerValue >= 11 && HH.integerValue < 16) {
      cell.mealTypeLabel.text = @"Lunch";
   } else {
      cell.mealTypeLabel.text = @"Dinner";
   }
//   cell.mealTypeLabel.text = @"Lunch";
   cell.dateTimeLabel.text = [NSString stringWithFormat:@"%@", dateString];
   cell.scanIdLabel.text = [NSString stringWithFormat:@"%@", hd.scan_id];
   
   cell.profileColorImageView.image = [UIImage imageNamed:[profileColorThumbnails objectAtIndex:(indexPath.row%8)]];
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checked = !cell.checked;
    if (cell.checked) {
        [cell.checkmarkImage setHidden:NO];
    } else {
        [cell.checkmarkImage setHidden:YES];
    }
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return 64;
}

@end
