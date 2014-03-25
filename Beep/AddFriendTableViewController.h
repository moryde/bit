//
//  AddFriendTableViewController.h
//  Beep
//
//  Created by Morten Ydefeldt on 19/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackendConnection.h"

@interface AddFriendTableViewController : UITableViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchUsers;
@property (nonatomic) NSArray *allUsers;
@property (nonatomic) BackendConnection *backendConnection;
@property (nonatomic) UIImage *image;
@end
