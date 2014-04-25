//
//  CreateUserViewController.m
//  Beep
//
//  Created by Morten Ydefeldt on 18/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "CreateUserViewController.h"
#import "AppDelegate.h"
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
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *devToken = [[[[appDelegate.deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
        
    if ([self.passwordTextfield.text isEqualToString: self.rePasswordTextfield.text]) {
        [self.backendConnection createNewUserWithUsername:self.usernameTextfield.text password:self.passwordTextfield.text deviceToken:devToken];
    
    }else {
        NSLog(@"passwords do not match");
    }
    
    
}
@end
