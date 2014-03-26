//
//  ViewController.m
//  Beep
//
//  Created by Morten Ydefeldt on 16/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController () {
}

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.backendConnection = [BackendConnection getInstance];
    [self.backendConnection prepareDataForLoggedInUser];
    [self.backendConnection setDelegate:self];
    [self.tableView reloadData ];
    
}

- (bool)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"log out"]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
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
    if (section == 1 && self.backendConnection.friendRequests) {
        return self.backendConnection.friendRequests.count;
    }
    
    if (section == 0 && self.backendConnection.friendRequests) {
        return self.backendConnection.friends.count;
    }
    
    return self.backendConnection.friends.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.backendConnection.friendRequests) {
        return 2;
    }else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Friends";
    }else{
        return @"Friends Requests";
    }
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"user" forIndexPath:indexPath];
    

    NSString *username = [[NSString alloc] init];

    [cell.textLabel setText:@"ANON"];
    [cell.imageView setImage:self.backendConnection.standardImage];

    if (indexPath.section == 1 && self.backendConnection.friendRequests) {
        [cell.detailTextLabel setText:@"Friend Request"];
        self.backendConnection = [BackendConnection getInstance];
        NSDictionary *user = [[NSDictionary alloc] initWithDictionary:[self.backendConnection.friendRequests objectAtIndex:indexPath.row]];
        username = [user objectForKey:@"username"];

        
        [cell.textLabel setText:username];

    }
    if (indexPath.section == 0 && self.backendConnection.friendRequests) {
        NSDictionary *user = [[NSDictionary alloc] initWithDictionary:[self.backendConnection.friends objectAtIndex:indexPath.row]];
        username = [user objectForKey:@"username"];

        
        [cell.textLabel setText:username];
        [cell.detailTextLabel setText:@"Friend"];
    } else if(indexPath.section==0){
        NSDictionary *user = [[NSDictionary alloc] initWithDictionary:[self.backendConnection.friends objectAtIndex:indexPath.row]];
        username = [user objectForKey:@"username"];
        
        
        [cell.textLabel setText:username];
        [cell.detailTextLabel setText:@"Friend"];
    }


    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        [self.backendConnection responsTofriendRequestFromFriend:[self.backendConnection.friendRequests objectAtIndex:indexPath.row] withResponse:YES];
    } else {
        [self.backendConnection sendNotificationToUserAtIndexPath:indexPath];
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (IBAction)reloadTableViewButton:(UIButton *)sender {
    [self.tableView reloadData];
}
@end
