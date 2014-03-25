//
//  ViewController.h
//  Beep
//
//  Created by Morten Ydefeldt on 16/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackendConnection.h"

@interface ViewController : UIViewController <UITableViewDataSource, UITabBarDelegate, BackendConnectionDelegate, UITextFieldDelegate> {
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BackendConnection *backendConnection;

- (IBAction)loginButtonPressed:(UIButton *)sender;

- (IBAction)reloadTableViewButton:(UIButton *)sender;
@end