//
//  ViewController.h
//  Beep
//
//  Created by Morten Ydefeldt on 16/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITabBarDelegate, UITextFieldDelegate> {
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *friends;
@property (nonatomic) NSArray *activity;

@end