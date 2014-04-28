//
//  LoginViewController.h
//  Beep
//
//  Created by Morten Ydefeldt on 18/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "ViewController.h"
#import "backendConnection.h"
@interface LoginViewController : ViewController <BackendConnectionDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *something;

@property (nonatomic) BackendConnection *backendConnection;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;

- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)newUserButtonPressed:(id)sender;


@end
