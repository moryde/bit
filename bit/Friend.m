//
//  Friend.m
//  bit
//
//  Created by Morten Ydefeldt on 14/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "Friend.h"
#import "BackendConnection.h"

@implementation Friend



-(void)acceptFriendRequest {
    [self.backendConnection responsTofriendRequestFromFriend:self withResponse:YES];
}

-(void)sendNotification {

    [self.backendConnection sendNotificationToFriend:self];
    
}

@end