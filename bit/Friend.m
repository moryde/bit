//
//  Friend.m
//  bit
//
//  Created by Morten Ydefeldt on 11/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "Friend.h"

@implementation Friend


- (Friend*)initWithResponseObject: (NSDictionary*)responseObject {

    self = [super init];
    if (self) {
        [self setUsername:[responseObject objectForKey:@"username"]];
        self.userID = [[responseObject objectForKey:@"id"] integerValue];
    }
    return self;
}
@end
