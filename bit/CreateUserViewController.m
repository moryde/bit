//
//  CreateUserViewController.m
//  Beep
//
//  Created by Morten Ydefeldt on 18/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "CreateUserViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@interface CreateUserViewController ()

@end

@implementation CreateUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        NSInteger nextTag = textField.tag + 1;
        // Try to find next responder
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (nextResponder) {
            // Found next responder, so set it.
            [nextResponder becomeFirstResponder];
        } else {
            // Not found, so remove keyboard.
            [textField resignFirstResponder];
            [self createUserButton:nil];
        }
        return NO; // We do not want UITextField to insert line-breaks.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == 1 || textField.tag == 2) {
        [textField setSecureTextEntry:YES];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.backendConnection = [BackendConnection getInstance];
    self.backendConnection.delegate = self;
}

-(void)userCreated:(BOOL)sucess{
    if (sucess) {
        [self performSegueWithIdentifier:@"back to login screen" sender:self];
    }
    else {
        NSLog(@"user not created");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createUserButton:(UIButton *)sender {
    
    NSString *user = [self.usernameTextfield text];
    NSString *pass = [self.passwordTextfield text];
    
    if ([user length] < 4 || [pass length] < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Username and Password must both be at least 4 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    
    else {
        
        [self.activityIndicator startAnimating];
        
        PFUser *newUser = [PFUser user];
        newUser.username = user;
        newUser.password = pass;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.activityIndicator stopAnimating];
            if (error) {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
                //[self performSegueWithIdentifier:@"signupToMain" sender:self];
            }
        }];
    }
    
    
}
@end
