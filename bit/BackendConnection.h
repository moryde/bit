//
//  BackendConnection.h
//  Beep
//
//  Created by Morten Ydefeldt on 17/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "User.h"
#import "Friend.h"

@class Friend, User;

@protocol BackendConnectionDelegate;

@interface BackendConnection : NSObject

+ (BackendConnection*) getInstance;

@property (nonatomic,strong) id <BackendConnectionDelegate> delegate;
@property (nonatomic) NSMutableArray *allUsers;
@property (nonatomic) User *loggedInUser;

- (NSDictionary*)loginWithUsername:(NSString*)username password:(NSString*)password;

- (void)sendNotificationToFriend:(Friend*) friend;
- (void)createNewUserWithUsername: (NSString*)userName password: (NSString*)password deviceToken: (NSString*)deviceToken;
- (void)prepareToGetAllUsers;
- (void)sendFriendRequestTo:(User*)user;
- (void)responsTofriendRequestFromFriend:(Friend*)friend withResponse:(BOOL)response;

@end

@protocol BackendConnectionDelegate
@optional
- (void)userLoggedIn:(User*)user;
- (void)getInitialData:(NSArray*)friends;
- (void)getAllUsers:(NSArray*)allUsers;
- (void) userCreated: (BOOL)sucess;
@end
