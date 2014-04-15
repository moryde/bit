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

- (NSArray *)blockedFriends{
    
    return [self.relations objectForKey:@"0"];
}

- (NSArray *)friends{
    
    return [self.relations objectForKey:@"1"];
}

- (NSArray *)friendRequets{
    
    return [self.relations objectForKey:@"2"];
}

- (NSArray *)sendRequests{
    
    return [self.relations objectForKey:@"3"];
}



- (NSMutableDictionary *)relations {
    
    if (!_relations) {
        _relations = [[NSMutableDictionary alloc] init];
    }
    return _relations;
}

-(void)sendFriendRequest {
    
    [self.backendConnection sendFriendRequestTo:self];
    
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
            if (![self.relations objectForKey:[tempFriend objectForKey:@"type"]]) {
                NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:friend, nil];
                [self.relations setObject:array forKey:[tempFriend objectForKey:@"type"]];
            }else {
                [[self.relations objectForKey:[tempFriend objectForKey:@"type"]] addObject:friend];
            }
        }
    }

}
    return self;
}

- (int)countTypeOfFriends {
    
    return 1;
    
}

@end