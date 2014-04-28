//
//  PossibleFriendTableViewCell.m
//  bit
//
//  Created by Morten Ydefeldt on 28/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "PossibleFriendTableViewCell.h"

@implementation PossibleFriendTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
