//
//  BackendConnection.m
//  Beep
//
//  Created by Morten Ydefeldt on 17/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#define serverURL = "http://www.ydefeldt.com/beep/"

#import "BackendConnection.h"
#import "Friend.h"
#import "User.h"

@implementation BackendConnection

static BackendConnection *singletonInstance;


+ (BackendConnection*)getInstance {
    
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    
    return singletonInstance;
}

- (NSMutableArray*) allUsers {
    
    if (!_allUsers) {
        _allUsers = [[NSMutableArray alloc] init];
    }
    return _allUsers;
}

- (void)responsTofriendRequestFromFriend:(Friend*)friend withResponse:(BOOL)response {

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"myID": self.loggedInUser.userID, @"friendID": [NSString stringWithFormat:@"%ldl",(long)friend.userID]};
    [manager POST:@"http://www.ydefeldt.com/beep/acceptFriendRequest.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Accepted Friend Request");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FriendRequestAcceptionError");
        NSLog(@"Error: %@", error);
    }];

    
}

-(User*)loginWithUsername:(NSString*)username password:(NSString*)password {
    
    NSDictionary *parameters = @{@"password": password, @"username": username};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://www.ydefeldt.com/beep/login.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject isKindOfClass:[NSDictionary class]]) {
            if(![responseObject objectForKey:@"error"]){
                self.loggedInUser = [[User alloc] initWithUserDictionary:responseObject];
                NSUserDefaults *defs = [[NSUserDefaults alloc] init];
                [defs setObject:@"1" forKey:@"loggedIn"];
                [self.delegate userLoggedIn:self.loggedInUser];
            }
            else {
                [self.delegate userLoggedIn:self.loggedInUser];
            }
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    if (self.loggedInUser.userName) {
        NSLog(@"User init");
        return self.loggedInUser;
    }else{
        NSLog(@"OMG");
        return nil;
    }
}


- (void) createNewUserWithUsername: (NSString*)userName
                          password: (NSString*)password
                       deviceToken: (NSString*)deviceToken {
    
    NSDictionary *newUser = @{@"username": userName,@"password":password,@"device_token":deviceToken};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    [manager POST:@"http://www.ydefeldt.com/beep/createUser.php" parameters:newUser success:^(AFHTTPRequestOperation *opration, id responseObject){
        if([responseObject isKindOfClass:[NSDictionary class]]){
            [self.delegate userCreated:YES];
            self.loggedInUser = [[User alloc ]initWithUserDictionary:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to create user");
        [self.delegate userCreated:NO];
    }];
    
}


- (void)sendFriendRequestTo:(User*)user {
    if (self.loggedInUser) {
        NSDictionary *parameters = @{@"sender_id": self.loggedInUser.userID ,@"receiver_id": user.userID};

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://ydefeldt.com/beep/sendFriendRequest.php" parameters:parameters success:^(AFHTTPRequestOperation *opration, id responseObject){
            NSLog(@"Friend request send with success");

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Friend request not JSON object");

        }];
    }
    
}



-(void)prepareToGetAllUsers {
    self.allUsers = [[NSMutableArray alloc] init];
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://www.ydefeldt.com/beep/getUsers.php" parameters:nil success:^(AFHTTPRequestOperation *opration, id responseObject){
            for (User* user in responseObject) {
                [self.allUsers addObject:user];
            }
            [self.delegate getAllUsers:self.allUsers];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Get all Users not JSON object");
        }];
}

- (void)sendNotificationToFriend:(Friend*) friend {
    if (self.loggedInUser) {

        NSDictionary *parameters = @{@"sender": self.loggedInUser.userID, @"receiver": friend.userID, @"messageType": @"0"};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://www.ydefeldt.com/beep/sendMessage.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Send notification not JSON object");
        }];
    }

    
    
}

@end