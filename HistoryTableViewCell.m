//
//  HistoryTableViewCell.m
//  Dietskan
//
//  Created by Zach Feingold on 5/26/16.
//  Copyright © 2016 DietSkan. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.checked = false;
    [self.checkmarkImage setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
