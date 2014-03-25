//
//  LoginViewController.h
//  Beep
//
//  Created by Morten Ydefeldt on 18/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"
#import "backendConnection.h"
@interface LoginViewController : ViewController <BackendConnectionDelegate>

- (IBAction)loginButtonPressed:(UIButton *)sender;

@property (nonatomic) BackendConnection *backendConnection;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end