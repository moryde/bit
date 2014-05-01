//
//  ChannelsViewController.m
//  bit
//
//  Created by Morten Ydefeldt on 24/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ChannelsViewController.h"

@interface ChannelsViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ChannelsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) prepareData {
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:@"Channel"];
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.channels = objects;
            //[self.tableView reloadData];
        }
        
    }];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.tabelView reloadData];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated{
    [self.tabelView reloadData];
    [self prepareData];
    NSLog(@"This is a test");

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%i Channel with this user", self.channels.count);
    return self.channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"channelCell"];
    PFObject *channel = [self.channels objectAtIndex:indexPath.row];
    cell.textLabel.text = channel[@"name"];
    return cell;
    
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

@end
