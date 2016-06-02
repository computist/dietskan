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

int checkCnt;
NSMutableArray *tableData;
NSMutableArray *allTableData;
NSArray *profileColorThumbnails;

static NSString *cellIdentifier = @"historyTableCell";

- (void) sort: (int)index {
    tableData = [[tableData sortedArrayUsingComparator:^NSComparisonResult(HistoryData *h1, HistoryData *h2){
        if (index == 0) {
            // sort by scan id
            return [h1.scan_id compare:h2.scan_id];
        } else if (index == 1) {
            // sort by meal
            NSDateFormatter *formatter;
            NSString        *dateString;
            int h1t, h2t;
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            dateString = [formatter stringFromDate:h1.date];
            
            NSString *HH = [dateString substringWithRange:NSMakeRange(11, 2)];
            if (HH.integerValue < 11) {
                h1t = 0;
            } else if (HH.integerValue >= 11 && HH.integerValue < 16) {
                h1t = 1;
            } else {
                h1t = 2;
            }
            
            dateString = [formatter stringFromDate:h2.date];
            
            HH = [dateString substringWithRange:NSMakeRange(11, 2)];
            if (HH.integerValue < 11) {
                h2t = 0;
            } else if (HH.integerValue >= 11 && HH.integerValue < 16) {
                h2t = 1;
            } else {
                h2t = 2;
            }
            
            return h1t <= h2t;
        } else if (index == 2) {
            // sort by date
            NSDateFormatter *formatter;
            NSString        *dateString;
            NSArray *h1arr;
            NSArray *h2arr;
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
            dateString = [formatter stringFromDate:h1.date];
            h1arr = [dateString componentsSeparatedByString: @"_"];
            
            dateString = [formatter stringFromDate:h2.date];
            h2arr = [dateString componentsSeparatedByString: @"_"];
            
            NSArray *arr = [NSArray arrayWithObjects:h1arr[0], h1arr[1], h1arr[2], nil];
            NSString *h1t =[arr componentsJoinedByString:@"_"];
            arr = [NSArray arrayWithObjects:h2arr[0], h2arr[1], h2arr[2], nil];
            NSString *h2t =[arr componentsJoinedByString:@"_"];
            return [h1t compare:h2t];
            
        } else {
            // sort by time
            NSDateFormatter *formatter;
            NSString        *dateString;
            NSArray *h1arr;
            NSArray *h2arr;
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
            dateString = [formatter stringFromDate:h1.date];
            h1arr = [dateString componentsSeparatedByString: @"_"];
            
            dateString = [formatter stringFromDate:h2.date];
            h2arr = [dateString componentsSeparatedByString: @"_"];
            
            NSArray *arr = [NSArray arrayWithObjects:h1arr[3], h1arr[4], h1arr[5], nil];
            NSString *h1t =[arr componentsJoinedByString:@"_"];
            arr = [NSArray arrayWithObjects:h2arr[3], h2arr[4], h2arr[5], nil];
            NSString *h2t =[arr componentsJoinedByString:@"_"];
            return [h1t compare:h2t];
        }
        
        
    }] mutableCopy];
    
    [self.tableView reloadData];
}

- (IBAction)sortFilterChange:(UISegmentedControl *)sender {
    [self sort:(int)sender.selectedSegmentIndex];
}

- (IBAction)backClick:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // OK
        NSLog(@"OK clicked");
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
        [allTableData removeObjectsAtIndexes:deleteArray];
        [self.tableView reloadData];
        
        [self clearSelect];
    }
    if (buttonIndex == 1) {
        // cancel
        NSLog(@"Cancel clicked");
    }
}

- (IBAction)removeClick:(UIButton *)sender {
    if (checkCnt > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:[NSString stringWithFormat:@"Do you really want to delete %d files checked?.", checkCnt] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [alert show];
    }
}

- (void) clearSelect {
    for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:0]; ++i)
    {
        HistoryTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.checked = false;
        [cell.checkmarkImage setHidden:YES];
    }
    checkCnt = 0;
}

- (IBAction)clearSelectClick:(UIButton *)sender {
    [self clearSelect];
}

- (void)viewDidLoad {
   [super viewDidLoad];
   tableData = [NSMutableArray new];
    allTableData = [NSMutableArray new];
   // Do any additional setup after loading the view from its nib.
   self.tableView.delegate = self;
   self.tableView.dataSource = self;
   self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
   self.restClient.delegate = self;
   
   UINib *cellNib = [UINib nibWithNibName:@"HistoryTableViewCell" bundle:nil];
   [self.tableView registerNib:cellNib forCellReuseIdentifier: cellIdentifier];
   
    [tableData removeAllObjects];
    [allTableData removeAllObjects];
   [self.restClient loadMetadata:@"/Scan"];
    checkCnt = 0;
   
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
                 [allTableData addObject:hd];
             }
         }
      }
      [self.tableView reloadData];
   }
}

-(void) search:(NSString *)searchText {
    if (![searchText isEqualToString:@""]) {
        [tableData removeAllObjects];
        for (HistoryData *h in allTableData) {
            if ([h.scan_id containsString:searchText]) {
                [tableData addObject:h];
                continue;
            }
            NSDateFormatter *formatter;
            NSString        *dateString;
            formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            dateString = [formatter stringFromDate:h.date];
            NSString *mealType;
            NSString *HH = [dateString substringWithRange:NSMakeRange(11, 2)];
            if (HH.integerValue < 11) {
                mealType = @"Breakfast";
            } else if (HH.integerValue >= 11 && HH.integerValue < 16) {
                mealType = @"Lunch";
            } else {
                mealType = @"Dinner";
            }
            if ([mealType containsString:searchText]) {
                [tableData addObject:h];
                continue;
            }
            if ([dateString containsString:searchText]) {
                [tableData addObject:h];
                continue;
            }
        }
        [self sort: (int)self.sortSegmentedControl.selectedSegmentIndex];
        [self.tableView reloadData];
    } else {
        [tableData removeAllObjects];
        for (HistoryData *h in allTableData) {
            [tableData addObject:h];
        }
        [self sort: (int)self.sortSegmentedControl.selectedSegmentIndex];
        [self.tableView reloadData];
    }

}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self search:searchBar.text];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self search:searchBar.text];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self search:searchBar.text];
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
    [tableData removeAllObjects];
    [allTableData removeAllObjects];
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
   
    if (cell.checked) {
        [cell.checkmarkImage setHidden:NO];
    } else {
        
        [cell.checkmarkImage setHidden:YES];
    }
    
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.checked = !cell.checked;
    if (cell.checked) {
        checkCnt++;
        [cell.checkmarkImage setHidden:NO];
    } else {
        checkCnt--;
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
