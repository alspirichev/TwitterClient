//
//  ASSignInViewController.h
//  
//
//  Created by Alexander Spirichev on 07.09.15.
//
//

#import <UIKit/UIKit.h>

@interface ASLoginViewController : UIViewController <UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
