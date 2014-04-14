//
//  Friend.h
//  bit
//
//  Created by Morten Ydefeldt on 11/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject

@property (nonatomic) NSString* username;
@property (nonatomic) NSInteger userID;
@property (nonatomic) UIImage* userImage;


- (Friend*) initWithResponseObject:(NSDictionary*) responseObject;

@end
