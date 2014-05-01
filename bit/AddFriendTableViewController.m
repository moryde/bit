//
//  AddFriendTableViewController.m
//  Beep
//
//  Created by Morten Ydefeldt on 19/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "AddFriendTableViewController.h"
#import "ViewController.h"
#import <Parse/Parse.h>
#import "PossibleFriendTableViewCell.h"
@interface AddFriendTableViewController ()

@end

@implementation AddFriendTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.users = [[NSArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"AddFriendViewController loaded");
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.users = objects;
    }];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    NSLog(@"SEARCH DONE");
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepare for segue");
}

-(void)viewWillAppear:(BOOL)animated {

    [self.searchUsers setDelegate:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //User *user = [self.backendConnection.allUsers objectAtIndex:indexPath.row];
    //[user sendFriendRequest];
    PFUser *user = [PFUser currentUser];
    PFUser *reciever = [self.users objectAtIndex:indexPath.row];
    
    PFObject *relations = [PFObject objectWithClassName:@"Relations"];
    
    relations[@"sendingUser"] = user;
    relations[@"receivingUser"] = reciever;
    relations[@"type"] = @"0";
    
    [relations saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PossibleFriendTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

            [UIView transitionWithView:cell.imageViewRight
                              duration:0.3f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                cell.imageViewRight.image = [UIImage imageNamed:@"requestSend.png"];
                                cell.selected = NO;
                            } completion:nil];
            
        }
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFUser *user = [self.users objectAtIndex:indexPath.row];
    PossibleFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    cell.textLabel.text = user.username;
    
    PFFile *PFimage = user[@"avatar"];
    
    [PFimage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        cell.imageView.image = image;
        cell.imageView.layer.cornerRadius = 25;
    }];
    
    return cell;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
