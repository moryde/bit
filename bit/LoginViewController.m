//
//  LoginViewController.m
//  Beep
//
//  Created by Morten Ydefeldt on 18/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "LoginViewController.h"

#import <Parse/Parse.h>
@interface LoginViewController ()
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)getInitialData:(NSArray *)friends {
    NSLog(@"DATA CAME WRONG");
}

- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
}


-(void) viewDidAppear:(BOOL)animated {
    // Do any additional setup after loading the view.
       
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *loggedIn = [prefs stringForKey:@"loggedIn"];
    
    if (loggedIn) {
        [self performSegueWithIdentifier:@"logged in" sender:self];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {

    self.usernameTextField.layer.cornerRadius = 22;
    self.passwordTextField.layer.cornerRadius = 22;
    self.password2TextField.layer.cornerRadius = 22;
    self.loginButton.layer.cornerRadius = 22;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [self.passwordTextField setSecureTextEntry:NO];
    [self.passwordTextField setText:@"Password"];
    self.password2TextField.hidden = YES;
    self.password2TextField.alpha = 0.0;
    NSString *username = [prefs stringForKey:@"username"];
    
    if (username) {
        self.usernameTextField.text = username;
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass:[ViewController class]]) {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:nil forKey:@"loggedIn"];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    
    if ([identifier isEqualToString:@"createUser"]) {
        return YES;
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *loggedIn = [prefs stringForKey:@"loggedIn"];
    NSLog(@"%@%@",@"ShoulPerformWith username",loggedIn);
    if (loggedIn) {
        return YES;
    }else{
        return NO;
    }

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        [textField setSecureTextEntry:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        if (textField.tag == 0) {
            [textField setText:@"Username"];
        } else if (textField.tag == 1) {
            [textField setSecureTextEntry:NO];
            [textField setText:@"Password"];
        }
    }
}


- (IBAction)loginButtonPressed:(UIButton *)sender {
    //[[BackendConnection getInstance] loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
    //[sender setEnabled:NO];
    
    
    NSString *user = [self.usernameTextField text];
    NSString *pass = [self.passwordTextField text];
    
    if ([user length] < 4 || [pass length] < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Username and Password must both be at least 4 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else if(self.password2TextField.isHidden){
        [self.activityIndicator startAnimating];
        [PFUser logInWithUsernameInBackground:user password:pass block:^(PFUser *user, NSError *error) {
            [self.activityIndicator stopAnimating];
            if (user) {
                [self dismissViewControllerAnimated:YES completion:nil];
                //[self performSegueWithIdentifier:@"loginToMain" sender:self];
            } else {
                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"Invalid Username and/or Password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else if (!self.password2TextField.isHidden) {
        
        if (![self.password2TextField.text isEqualToString:self.passwordTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to create user" message:@"Passwords do not match" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
        
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

- (IBAction)newUserButtonPressed:(id)sender {
    
    if ([self.password2TextField isHidden]) {
        //[self.loginButton setTitle:@"Create user and login" forState:UIControlStateNormal];
        self.password2TextField.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^() {
            CGRect frame = self.loginButton.frame;
            CGRect frame2 = self.something.frame;
            
            frame2.origin.y = frame2.origin.y + self.password2TextField.frame.size.height +8;
            frame.origin.y = frame.origin.y + self.password2TextField.frame.size.height +8;
            [self.loginButton setFrame:frame];
            [self.something setFrame:frame2];
        }completion:^(BOOL finished) {
            if (finished) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.password2TextField.alpha = 0.5;
                }];
            }
        }];
        
    } else{
        [UIView animateWithDuration:0.3 animations:^() {
            self.password2TextField.alpha = 0.5;
        } completion:^(BOOL finished) {
            if (finished) {
                self.password2TextField.hidden = YES;
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect frame = self.loginButton.frame;
                    CGRect frame2 = self.something.frame;
                    
                    frame2.origin.y = frame2.origin.y - self.password2TextField.frame.size.height - 8;
                    frame.origin.y = frame.origin.y - self.password2TextField.frame.size.height - 8;
                    [self.loginButton setFrame:frame];
                    [self.something setFrame:frame2];
                    //[self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
                    
                }];
            }
        }
         
         
         ];
    }
    
}
@end
