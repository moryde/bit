//
//  AddOrEditChannelViewController.h
//  bit
//
//  Created by Morten Ydefeldt on 28/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"

@interface AddOrEditChannelViewController : ViewController
- (IBAction)createChannelButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *channelNameTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isPublicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isOpenSwitch;

@end
