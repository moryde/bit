//
//  ViewController.m
//  Beep
//
//  Created by Morten Ydefeldt on 16/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "Friend.h"
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
    [PFUser logOut];
    if ([PFUser currentUser]) {
        
        PFUser *user = [PFUser currentUser];
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation setObject:[PFUser currentUser].objectId forKey:@"user"];
        [currentInstallation saveEventually];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Relations"];
        [query whereKey:@"receivingUser" equalTo:user];
        self.friends = [query findObjects];
    }
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    

    
}

- (void)refreshTable {
    //TODO: refresh your data
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    NSLog(@"RefreshControlEnded");
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.backendConnection = [BackendConnection getInstance];
    [self.backendConnection setDelegate:self];
    [self.tableView reloadData];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor grayColor];
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
//        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
//        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
//        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
//        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
//        
        // Assign our sign up controller to be displayed from the login controller
       // [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
       // [self presentViewController:logInViewController animated:YES completion:NULL];
        //LoginViewController *loginViewController = [[LoginViewController alloc] init];
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

- (void)getInitialData:(NSArray *)friends {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friends.count;
    NSArray *keys = [self.backendConnection.loggedInUser.relations allKeys];
    NSString *key = keys[section];
    return [[self.backendConnection.loggedInUser.relations objectForKey:key] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {


    return @"Friends";
}

-(NSData *)dataFromBase64EncodedString:(NSString *)string{
    if (string.length > 0) {
        
        //the iPhone has base 64 decoding built in but not obviously. The trick is to
        //create a data url that's base 64 encoded and ask an NSData to load it.
        NSString *data64URLString = [NSString stringWithFormat:@"data:;base64,%@", string];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:data64URLString]];
        return data;
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFUser *myFriend = [[self.friends objectAtIndex:indexPath.row] objectForKey:@"sendingUser"];
    [myFriend fetchIfNeeded];

    FriendTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"friendWithQuestion" forIndexPath:indexPath];
    PFFile *PFimage = myFriend[@"avatar"];
    
    [PFimage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        cell2.imageView.image = image;
    }];
    
    [cell2.textLabel setText:myFriend.username];
    return cell2;
    
    NSArray* keys = [self.backendConnection.loggedInUser.relations allKeys];
    
    NSString *key = keys[indexPath.section];
    NSLog(@"Key %@", key);
   Friend *friend = [[self.backendConnection.loggedInUser.relations objectForKey:key] objectAtIndex:indexPath.row];
    
    
    if ([key isEqualToString:@"1"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blockedUser" forIndexPath:indexPath];
        [cell.imageView setImage:self.backendConnection.loggedInUser.userImage];
        [cell.textLabel setText: friend.userName];
        return cell;
    
    } else if ([key isEqualToString:@"2"]) {
        if (!friend.question) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
            [cell.textLabel setText:[friend.userName uppercaseString]];
            return cell;

        } else {
            FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendWithQuestion"];
            [cell.myLabel setText:[friend.userName uppercaseString]];
            return cell;

        }
    }

        else if ([key isEqualToString:@"3"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendRequest" forIndexPath:indexPath];
        [cell.detailTextLabel setText:@"Friend"];
        [cell.imageView setImage:self.backendConnection.loggedInUser.userImage];
        [cell.textLabel setText: friend.userName];
        return cell;
    }

    else if ([key isEqualToString:@"4"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sendRequest" forIndexPath:indexPath];
        [cell.detailTextLabel setText:@"Friend"];
        [cell.imageView setImage:self.backendConnection.loggedInUser.userImage];
        [cell.textLabel setText: friend.userName];
        return cell;
    }
    
        return nil;

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
        
        [push setQuery:query]; // Set our Installation query
        [push setMessage:[NSString stringWithFormat:@"%@ send you a bit",[PFUser currentUser].username]];
        [push setData:data];
        [push sendPushInBackground];
    }
    [relation saveInBackground];

}

- (IBAction)reloadTableViewButton:(UIButton *)sender {
    [self.tableView reloadData];
}
@end
