//
//  AddOrEditChannelViewController.m
//  bit
//
//  Created by Morten Ydefeldt on 28/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "AddOrEditChannelViewController.h"
#import <Parse/Parse.h>
@interface AddOrEditChannelViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation AddOrEditChannelViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (bool)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:17/255.0 green:168/255.0 blue:170/255.0 alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createChannelButtonAction:(UIButton *)sender {
    
    PFObject *channel = [[PFObject alloc] initWithClassName:@"Channel"];
    PFRelation *relation = [[PFRelation alloc] init];
    [relation addObject:[PFUser currentUser]];
    channel[@"createdBy"] = [PFUser currentUser];
    channel[@"name"] = self.channelNameTextField.text;
    channel[@"isPublic"] = [NSNumber numberWithBool:[self.isPublicSwitch isOn]];
    channel[@"isOpen"] = [NSNumber numberWithBool:[self.isOpenSwitch isOn]];
    [channel saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
@end
