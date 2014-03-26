//
//  BackendConnection.m
//  Beep
//
//  Created by Morten Ydefeldt on 17/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#define serverURL = "http://www.ydefeldt.com/beep/"

#import "BackendConnection.h"

@implementation BackendConnection

static BackendConnection *singletonInstance;


+ (BackendConnection*)getInstance {
    
    if (singletonInstance == nil) {
        singletonInstance = [[super alloc] init];
    }
    
    return singletonInstance;
}

- (UIImage*) preparePicture {
    
    NSURL *url = [NSURL URLWithString:@"http://midtfynsbryghus.mmd.eal.dk/group5/sveinn.jpg"];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    self.standardImage = [UIImage imageWithData:imageData];
    return self.standardImage;
}

- (void) responsTofriendRequestFromFriend:(NSDictionary*)friend
                             withResponse:(BOOL)response {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"myID": [self.user objectForKey:@"id"], @"friendID": [friend objectForKey:@"id"]};
    [manager POST:@"http://www.ydefeldt.com/beep/acceptFriendRequest.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Accepted Friend Request");
        NSLog([responseObject description]);
        [self prepareDataForLoggedInUser];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FriendRequestAcceptionError");
        NSLog(@"Error: %@", error);
    }];

    
}

-(NSDictionary*)loginWithUsername:(NSString*)username password:(NSString*)password {
    [self preparePicture];
    self.user = [[NSDictionary alloc] init];
    
    NSDictionary *parameters = @{@"password": password, @"username": username};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:@"http://www.ydefeldt.com/beep/login.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.user = responseObject;
        if ([self.user valueForKey:@"username"]) {
            NSLog(@"Logged In");
            NSUserDefaults *defs = [[NSUserDefaults alloc] init];
            [defs setObject:@"1" forKey:@"loggedIn"];
            [self.delegate userLoggedIn:self.user];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

    if ([self.user valueForKey:@"username"]) {
        NSLog(@"User init");
        return self.user;
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
        NSLog(@"New user created");
        NSLog([responseObject description]);
        [self.delegate userCreated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Failed to create user");
        [self.delegate userCreated:NO];

    }];
    
}

- (void)getFriendRequests:(NSString*)ID {
    
    NSDictionary *parameters = @{@"id": [self.user objectForKey:@"id"]};
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:@"http://www.ydefeldt.com/beep/getFriendRequests.php" parameters:parameters success:^(AFHTTPRequestOperation *opration, id responseObject){
        
        if ([responseObject isKindOfClass:[NSArray class]]) {
            self.friendRequests = [[NSMutableArray alloc] init];
            self.friendRequests = responseObject;
            [self.delegate getInitialData:self.friendRequests];
        } else {
            self.friendRequests = nil;
            NSString *error = [responseObject objectForKey:@"error"];
            NSLog(error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to get friendRequests");
        NSLog([error description]);
    }];
    
}


-(void)prepareDataForLoggedInUser {

    if (self.user) {
        [self getFriendRequests:[self.user objectForKey:@"id"]];
        NSDictionary *parameters = @{@"id": [self.user objectForKey:@"id"]};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://www.ydefeldt.com/beep/getFriends.php" parameters:parameters success:^(AFHTTPRequestOperation *opration, id responseObject){
            self.friends = [[NSMutableArray alloc] init];
            self.friends = responseObject;
            [self.delegate getInitialData:self.friends];
            NSLog(@"FriendsReady");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Friend failed to fetch");
            NSLog([error description]);
        }];
    }
}

- (void)sendFriendRequestTo:(NSString*)receiverID {
    if (self.user) {
        NSDictionary *parameters = @{@"sender": [self.user objectForKey:@"id"],@"receiver": receiverID};
        NSLog([parameters description]);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://ydefeldt.com/beep/sendFriendRequest.php" parameters:parameters success:^(AFHTTPRequestOperation *opration, id responseObject){
            NSLog(@"Friend request send with success");
            NSLog([responseObject description]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Friend request not JSON object");
            NSLog([error debugDescription]);
        }];
    }
    
}



-(void)prepareToGetAllUsers {
    self.allUsers = [[NSMutableArray alloc] init];
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://www.ydefeldt.com/beep/getUsers.php" parameters:nil success:^(AFHTTPRequestOperation *opration, id responseObject){
            self.allUsers = responseObject;
            [self.delegate getAllUsers:self.allUsers];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Get all Users not JSON object");
        }];
}

-(void)sendNotificationToUserAtIndexPath:(NSIndexPath*)indexPath {
    if (self.user) {
        NSDictionary *userToSendNotification = [self.friends objectAtIndex:indexPath.row];
        NSDictionary *parameters = @{@"sender": [self.user objectForKey:@"id"], @"receiver": [userToSendNotification objectForKey:@"id"], @"messageType": @"0"};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://www.ydefeldt.com/beep/sendMessage.php" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Success");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Send notification not JSON object");
            NSLog(@"Error: %@", error);
        }];
    }

    
    
}

@end