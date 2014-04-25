//
//  channel.h
//  bit
//
//  Created by Morten Ydefeldt on 24/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Channel : NSObject

@property (nonatomic) NSString* owner;
@property (nonatomic) NSArray* subscribers;
@property (nonatomic) NSString* channelname;

@end
