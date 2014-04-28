//
//  ChannelsViewController.h
//  bit
//
//  Created by Morten Ydefeldt on 24/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
@interface ChannelsViewController : ViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (nonatomic) NSArray *channels;
@end