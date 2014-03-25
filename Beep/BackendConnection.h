//
//  BackendConnection.h
//  Beep
//
//  Created by Morten Ydefeldt on 17/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@protocol BackendConnectionDelegate;


@interface BackendConnection : NSObject

+ (BackendConnection*) getInstance;

@property (nonatomic,strong) id <BackendConnectionDelegate> delegate;

@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) NSString *urlString;
@property (nonatomic) NSDictionary *user;
@property (nonatomic) NSArray *allUsers;
@property (nonatomic) NSArray *friendRequests;

- (NSDictionary*)loginWithUsername:(NSString*)username password:(NSString*)password;

- (void)prepareDataForLoggedInUser;
- (void)sendNotificationToUserAtIndexPath:(NSIndexPath*)indexPath;
- (void) createNewUserWithUsername: (NSString*)userName password: (NSString*)password deviceToken: (NSString*)deviceToken;
- (void)prepareToGetAllUsers;
- (void)sendFriendRequestTo:(NSString*)receiverID;

@end

@protocol BackendConnectionDelegate
@optional
- (void)userLoggedIn:(NSDictionary*)user;
- (void)getInitialData:(NSArray*)friends;
- (void)getAllUsers:(NSArray*)allUsers;
- (void) userCreated: (BOOL)sucess;
@end
