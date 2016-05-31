//
//  HistoryTableViewCell.h
//  Dietskan
//
//  Created by Zach Feingold on 5/26/16.
//  Copyright © 2016 DietSkan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileColorImageView;
@property (weak, nonatomic) IBOutlet UILabel *scanIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mealTypeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImage;
@property bool checked;
@end
