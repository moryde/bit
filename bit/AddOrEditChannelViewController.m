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

- (void)viewWillAppear:(BOOL)animated{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createChannelButtonAction:(UIButton *)sender {
    
    PFObject *channel = [[PFObject alloc] initWithClassName:@"Channel"];
    PFRelation *relation = [[PFRelation alloc] init];
    [relation addObject:[PFUser currentUser]];
    channel[@"createdBy"] = [PFUser currentUser];
    channel[@"name"] = self.channelNameTextField.text;
    channel[@"isPublic"] = [NSNumber numberWithBool:[self.isPublicSwitch isOn]];
    channel[@"isOpen"] = [NSNumber numberWithBool:[self.isOpenSwitch isOn]];
    [channel saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self performSegueWithIdentifier:@"done editing channel" sender:self];
    }];
}
@end
