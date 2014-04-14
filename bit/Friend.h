//
//  Friend.h
//  bit
//
//  Created by Morten Ydefeldt on 14/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "User.h"

@interface Friend : User

@property (nonatomic) NSInteger type;

-(void)acceptFriendRequest;
-(void)sendNotification;

@end