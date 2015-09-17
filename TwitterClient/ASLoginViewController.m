//
//  ASSignInViewController.m
//  
//
//  Created by Alexander Spirichev on 07.09.15.
//
//

#import "ASLoginViewController.h"
#import "ViewController.h"

@interface ASLoginViewController ()

@end

@implementation ASLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.twitter.com/oauth2/token"]];
    
   [self.webView loadRequest:request]; 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (![self.loginField.text isEqualToString:@""]) {
        return YES;
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error!"
                                    message:@"Login is empty."
                                   delegate:self
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil, nil] show];
        return NO;
    }
   
    return NO;
}

#pragma mark - Navigation

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"twitterView"]) {
        
        UINavigationController* nav = segue.destinationViewController;
        
        ViewController* vc = (ViewController* ) nav.topViewController;
        
        vc.screenName = self.loginField.text;

    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        if ([self.loginField.text isEqualToString:@""]) {
            self.loginLabel.text = [NSString stringWithFormat:@"Login is empty."];
        } else {
            self.loginLabel.text = nil;
        }
    
    [self.loginField resignFirstResponder];
    
    return  YES;
}

@end
