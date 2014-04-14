//
//  User.h
//  bit
//
//  Created by Morten Ydefeldt on 14/04/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface User : NSObject {
    
}

@property (nonatomic) NSInteger userID;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSMutableArray *friends;
@property (nonatomic) UIImage *userImage;


- (User*)initWithResponseObject:(NSDictionary*)responseObject;
- (int)countTypeOfFriends;
@end
