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

- (IBAction)backClick:(UIButton *)sender {
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    tableData = [NSMutableArray new];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    [self.restClient loadMetadata:@"/Scan"];
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        [tableData removeAllObjects];
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            if ([file.filename hasSuffix:@".zip"]) {
                
                NSArray *chunks = [[file.filename stringByDeletingPathExtension] componentsSeparatedByString: @"_"];
                if (chunks.count == 7) {
                    HistoryData *hd = [HistoryData new];
                    hd.scan_id = chunks[1];
                    NSArray *arr = [NSArray arrayWithObjects:chunks[2], chunks[3], chunks[4], chunks[5], chunks[6], nil];
                    NSString *dateString = [arr componentsJoinedByString:@"_"];
                    
                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyyy_MM_dd_HH_mm"];
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
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    HistoryData *hd = tableData[indexPath.row];
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    dateString = [formatter stringFromDate:hd.date];
    
    cell.textLabel.text = [NSString stringWithFormat:@"ScanId: %@ DateTime: %@", hd.scan_id, dateString];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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

@end
