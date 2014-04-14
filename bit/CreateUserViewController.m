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
        // Custom initialization
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createUserButton:(UIButton *)sender {
    
    // Prepare the Device Token for Registration (remove spaces and < >)

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
