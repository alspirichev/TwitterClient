//
//  ASSignInViewController.h
//  
//
//  Created by Alexander Spirichev on 07.09.15.
//
//

#import <UIKit/UIKit.h>

@interface ASSignInViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;

- (IBAction)actionButton:(id)sender;

@end
