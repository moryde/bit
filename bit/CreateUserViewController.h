//
//  CreateUserViewController.h
//  Beep
//
//  Created by Morten Ydefeldt on 18/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"
#import "BackendConnection.h"
@interface CreateUserViewController : ViewController <BackendConnectionDelegate, UITextFieldDelegate>


@property (nonatomic)BackendConnection *backendConnection;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextfield;
- (IBAction)createUserButton:(UIButton *)sender;

@end
