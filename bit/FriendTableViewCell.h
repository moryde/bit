//
//  FriendTableViewCell.h
//  bit
//
//  Created by Morten Ydefeldt on 24/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumb;
- (IBAction)askQuestionButton:(id)sender;

@end
