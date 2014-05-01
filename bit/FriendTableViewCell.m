//
//  FriendTableViewCell.m
//  bit
//
//  Created by Morten Ydefeldt on 24/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "FriendTableViewCell.h"

@implementation FriendTableViewCell

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

- (void) setImageView:(UIImageView *)imageView {
    
    imageView.layer.borderWidth = 2;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.shadowColor = [UIColor grayColor].CGColor;
    imageView.layer.shadowOpacity = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)askQuestionButton:(id)sender {
    
    NSLog(@"LOL");
    
}
@end
