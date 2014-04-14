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
@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) UIImage *userImage;


- (instancetype)initWithUserDictionary:(NSDictionary*)userDictionary;
- (int)countTypeOfFriends;
- (void)sendFriendRequest;

@end
