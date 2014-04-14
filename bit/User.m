//
//  User.m
//  bit
//
//  Created by Morten Ydefeldt on 14/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "User.h"
#import "Friend.h"
#import "BackendConnection.h"

@implementation User

- (BackendConnection*)backendConnection {
    
    _backendConnection = [BackendConnection getInstance];
    return _backendConnection;
    
}

- (NSString *)userName {
    
    if (!_userName) {
        _userName = [[NSString alloc] init];
    }
    return _userName;
}

- (NSString *)userID {
    
    if (!_userID) {
        _userID = [[NSString alloc] init];
    }
    return _userID;
}

- (NSMutableArray *)friends {
    
    if (!_friends) {
        _friends = [[NSMutableArray alloc] init];
    }
    return _friends;
}

-(void)sendFriendRequest {
    
    
}

- (instancetype)initWithUserDictionary:(NSDictionary*)userDictionary {

    self = [super init];
    if (self) {
    self.userID = [userDictionary objectForKey:@"id"];
    self.userName = [userDictionary objectForKey:@"username"];
    
    if (![userDictionary objectForKey:@"image"]) {
        NSURL *url = [NSURL URLWithString:@"http://midtfynsbryghus.mmd.eal.dk/group5/sveinn.jpg"];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        self.userImage = [UIImage imageWithData:imageData];
    } else{
        self.userImage = [userDictionary objectForKey:@"image"];
    }
    if ([userDictionary objectForKey:@"friends"]) {
        for (NSDictionary *tempFriend in [userDictionary objectForKey:@"friends"]) {
            Friend *friend = [[Friend alloc] initWithUserDictionary:tempFriend];
            friend.type = [[tempFriend objectForKey:@"type"] integerValue];
            [self.friends addObject:friend];
        }
    }

}
    return self;
}

- (int)countTypeOfFriends {
    
    return 1;
    
}

@end