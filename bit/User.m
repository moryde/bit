//
//  User.m
//  bit
//
//  Created by Morten Ydefeldt on 14/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "User.h"
#import "Friend.h"

@implementation User

- (User*)initWithResponseObject:(NSDictionary*)responseObject {
    self = [super init];
    NSLog([responseObject description]);
    self.userID = [[responseObject objectForKey:@"id"] integerValue];
    self.userName = [responseObject objectForKey:@"username"];
    self.friends = [[NSMutableArray alloc] init];
    
    if (![responseObject objectForKey:@"image"]) {
        NSURL *url = [NSURL URLWithString:@"http://midtfynsbryghus.mmd.eal.dk/group5/sveinn.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        self.userImage = [UIImage imageWithData:imageData];
    } else{
        self.userImage = [responseObject objectForKey:@"image"];
    }
    for (NSDictionary *tempFriend in [responseObject objectForKey:@"friends"]) {
        Friend *friend = [[Friend alloc] init];
        [friend initWithResponseObject:tempFriend];
        [self.friends addObject:friend];
    }
    
    NSLog([self.friends description]);
    return self;
}

- (int)countTypeOfFriends {

    
    return 1;
    
}

@end