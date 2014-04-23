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
@interface ViewController () {
}

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) infoUpdated {
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.backendConnection = [BackendConnection getInstance];
    [self.backendConnection setDelegate:self];
    [self.tableView reloadData];
    [self.backendConnection updataInfo];
    
}
- (void)userLoggedIn:(User*)user {
    
}

- (bool)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"log out"]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        self.backendConnection.loggedInUser = nil;
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
    
    NSArray *keys = [self.backendConnection.loggedInUser.relations allKeys];
    NSString *key = keys[section];
    return [[self.backendConnection.loggedInUser.relations objectForKey:key] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"Number of section %lu",(unsigned long)[self.backendConnection.loggedInUser.relations count]);
    return [self.backendConnection.loggedInUser.relations count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [self.backendConnection.loggedInUser.relations allKeys];
    NSString *key = keys[section];
    
    if ([key isEqualToString:@"0"]) {
        return @"Blocked User";
    } else if ([key isEqualToString:@"1"]){
        return @"Friends";
    } else if ([key isEqualToString:@"2"]){
        return @"Send Request";
    } else if ([key isEqualToString:@"3"]){
        return @"Friend Request";
    }
    
    return @"fejl";
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
    
    NSArray* keys = [self.backendConnection.loggedInUser.relations allKeys];
    
    NSString *key = keys[indexPath.section];
    NSLog(@"Key %@", key);
   Friend *friend = [[self.backendConnection.loggedInUser.relations objectForKey:key] objectAtIndex:indexPath.row];

    
    if ([key isEqualToString:@"0"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"blockedUser" forIndexPath:indexPath];
        [cell.detailTextLabel setText:@"Friend"];
        [cell.imageView setImage:self.backendConnection.loggedInUser.userImage];
        [cell.textLabel setText: friend.userName];
        return cell;
    } else if ([key isEqualToString:@"1"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
        [cell.detailTextLabel setText:@"Friend"];
        [cell.imageView setImage:self.backendConnection.loggedInUser.userImage];
        [cell.textLabel setText: friend.userName];
        return cell;
    }
        else if ([key isEqualToString:@"2"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sendRequest" forIndexPath:indexPath];
        [cell.detailTextLabel setText:@"Friend"];
        [cell.imageView setImage:self.backendConnection.loggedInUser.userImage];
        [cell.textLabel setText: friend.userName];
        return cell;
    }
        else if ([key isEqualToString:@"3"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendRequest" forIndexPath:indexPath];
        [cell.detailTextLabel setText:@"Friend"];
        [cell.imageView setImage:self.backendConnection.loggedInUser.userImage];
        [cell.textLabel setText: friend.userName];
    return cell;
    }

    return nil;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray* keys = [self.backendConnection.loggedInUser.relations allKeys];
    NSString *key = keys[indexPath.section];
    NSLog(@"Key %@", key);
    Friend *friend = [[self.backendConnection.loggedInUser.relations objectForKey:key] objectAtIndex:indexPath.row];
    
    if (friend.type == 3) {
        [friend acceptFriendRequest];
    } else if (friend.type == 1){
        [friend sendNotification];
    } else if (friend.type == 0){
        NSLog(@"BLOCKED USER PRESSED");
    } else if (friend.type == 2){
        NSLog(@"YOU JUST PRESSED A FRIEND REQUEST WHICH YOU HAVE MADE, THERE IS NOTHING TO DO WITH IT");
    }

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (IBAction)reloadTableViewButton:(UIButton *)sender {
    [self.tableView reloadData];
}
@end
