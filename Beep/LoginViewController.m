//
//  LoginViewController.m
//  Beep
//
//  Created by Morten Ydefeldt on 18/03/14.
//  Copyright (c) 2014 Ydefeldt. All rights reserved.
//

#import "LoginViewController.h"

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


-(void) viewDidAppear:(BOOL)animated {
    // Do any additional setup after loading the view.
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *loggedIn = [prefs stringForKey:@"loggedIn"];
    
    if (loggedIn) {
        [self performSegueWithIdentifier:@"logged in" sender:self];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    self.backendConnection = [BackendConnection getInstance];
    [self.backendConnection prepareDataForLoggedInUser];
    [self.backendConnection setDelegate:self];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

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

-(void)userLoggedIn:(NSDictionary *)user {
    [self performSegueWithIdentifier:@"logged in" sender:self];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *userName = [user valueForKey:@"username"];
    if (userName) {
        [self performSegueWithIdentifier:@"logged in" sender:self];
        NSString *userName = [user valueForKey:@"username"];
        [prefs setObject:userName forKey:@"username"];
    }else{
        NSLog(@"could not log in");
    }

}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    [[BackendConnection getInstance] loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
    }
@end
