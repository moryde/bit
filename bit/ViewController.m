//
//  ViewController.m
//  Beep
//
//  Created by Morten Ydefeldt on 16/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "FriendTableViewCell.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface ViewController () <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>{

}
@property (nonatomic) UIRefreshControl *refreshControl;

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    if ([PFUser currentUser]) {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:[PFUser currentUser].objectId forKey:@"user"];
        [currentInstallation saveEventually];
        [self refreshTable];
    }
    
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    

    
}

- (void)refreshTable {
    NSLog(@"Refresh Table");
    PFUser *user = [PFUser currentUser];
    
    PFQuery *friendsQuery = [PFQuery queryWithClassName:@"Relations"];
    [friendsQuery whereKey:@"receivingUser" equalTo:user];
    [friendsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Recieved Friends");
        self.friends = objects;
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];

    }];
    
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"activity"];
    [activityQuery whereKey:@"receivingUser" equalTo:user];
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Recieved activity");
            self.activity = objects;
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];

        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated{
    //[self refreshTable];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (![PFUser currentUser]) { // No user logged in
        [self performSegueWithIdentifier:@"presentLoginController" sender:self];
    }
}

- (bool)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"log out"]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [PFUser logOut];
        [prefs setObject:nil forKey:@"loggedIn"];
        return YES;
    }
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"Number of row in section");
    
    switch (section) {
        case 0:
            if (self.activity.count == 0) {
                return 0;
            } else {
                return self.activity.count;
            }
            break;
        case 1:
            if (self.friends.count == 0) {
                return 0;
            } else {
                return self.friends.count;
            }
        default:
            return 0;
            NSLog(@"Exception in section count Viewcontroller");
            break;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];

    if (indexPath.section == 0) {
        PFObject *activity = [self.activity objectAtIndex:indexPath.row];
        PFUser *sendingUser = activity[@"sendingUser"];
        [sendingUser fetchIfNeeded];
        
        if ([activity[@"payload"] isEqualToString:@""]) {
            cell.titleLabel.text = [NSString stringWithFormat:@"%@ Send you a bit",sendingUser.username];
            PFFile *PFimage = sendingUser[@"avatar"];
            if (PFimage) {
                [PFimage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        cell.thumb.image = image;
                        //[self.tableView reloadData];
                    }
                }];
            } else{
                cell.thumb.image = [UIImage imageNamed:@"me_thumb.jpg"];
            }

        }
    }
    else if (indexPath.section == 1){
        PFUser *friend = [[self.friends objectAtIndex:indexPath.row] objectForKey:@"sendingUser"];
        [friend fetchIfNeeded];
        PFFile *PFimage = friend[@"avatar"];
        cell.titleLabel.text = friend.username;
        
        if (PFimage) {
            [PFimage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    cell.thumb.image = image;
                    //[self.tableView reloadData];
                }
            }];
        } else{
            cell.thumb.image = [UIImage imageNamed:@"me_thumb.jpg"];
        }
    }


    
    return cell;

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionHeaderText = [[NSString alloc] init];
    
    switch (section) {
        case 0:
            sectionHeaderText = @"Activity";
            break;
        case 1:
            sectionHeaderText = @"Friends";
            break;
        default:
            sectionHeaderText = @"Fail";
            break;
    }
    
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];

    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, tableView.frame.size.width, 18)];
    [headerLabel setFont:[UIFont boldSystemFontOfSize:14]];

    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setText:sectionHeaderText];
    [sectionView addSubview:headerLabel];
    [sectionView setBackgroundColor:[UIColor colorWithRed:17/255.0 green:168/255.0 blue:170/255.0 alpha:1.0]];
    return sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFObject *relation = [self.friends objectAtIndex:indexPath.row];
    
    if ([relation[@"type"] isEqualToString:@"0"]) {
        relation[@"type"] = @"1";
    } else if ([relation[@"type"] isEqualToString:@"1"]) {
        PFUser *myFriend = relation[@"receivingUser"];
        PFPush *push = [[PFPush alloc] init];
        PFQuery *query = [PFInstallation query];
        [query whereKey:@"user" equalTo:myFriend.objectId];
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Increment", @"badge",
                              @"cheering.caf", @"sound",
                              nil];
        [push setQuery:query];
        [push setMessage:[NSString stringWithFormat:@"%@ send you a bit",[PFUser currentUser].username]];
        [push setData:data];
        [push sendPushInBackground];
        
        PFObject *activity = [PFObject objectWithClassName:@"activity"];
        activity[@"receivingUser"] = myFriend;
        activity[@"sendingUser"] = [PFUser currentUser];
        activity[@"answer"] = @"";
        activity[@"payload"] = @"";
        [activity save];
    }
    [relation saveInBackground];

}


@end
