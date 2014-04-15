//
//  User.h
//  bit
//
//  Created by Morten Ydefeldt on 14/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BackendConnection;

@interface User : NSObject {
    
}
@property (nonatomic) BackendConnection* backendConnection;

@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSMutableDictionary *relations;
@property (nonatomic) UIImage *userImage;

@property (nonatomic) NSArray *friends;
@property (nonatomic) NSArray *friendRequets;
@property (nonatomic) NSArray *blockedFriends;
@property (nonatomic) NSArray *sendRequests;

- (instancetype)initWithUserDictionary:(NSDictionary*)userDictionary;
- (int)countTypeOfFriends;
- (void)sendFriendRequest;
- (NSArray*)getFriendsWithType:(NSInteger)type;

@end
