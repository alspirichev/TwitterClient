//
//  ASSignInViewController.m
//  
//
//  Created by Alexander Spirichev on 07.09.15.
//
//

#import "ASSignInViewController.h"
#import "ViewController.h"

@interface ASSignInViewController ()

@end

@implementation ASSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionButton:(id)sender {
    
    if ([self.loginField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Login or Password is empty."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
    }
}

#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"twitterView"]) {
        
        UINavigationController* nav = segue.destinationViewController;
        
        ViewController* vc = (ViewController* ) nav.topViewController;
        
        vc.login = self.loginField.text;
        vc.password = self.passwordField.text;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField isEqual:self.loginField]) {
        
        if ([self.loginField.text isEqualToString:@""]) {
            self.loginLabel.text = [NSString stringWithFormat:@"Login is empty."];
        } else {
            self.loginLabel.text = nil;
        }
        
        [self.passwordField becomeFirstResponder];
        
    } else {
        
        if ([self.passwordField.text isEqualToString:@""]) {
            self.passwordLabel.text = [NSString stringWithFormat:@"Password is empty."];
        } else {
            self.passwordLabel.text = nil;
        }
        
        [textField resignFirstResponder];
    }
    
    return  YES;
}

@end
