//
//  GPTInfoViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 31/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTInfoViewController.h"
#import "game_def.h"
#import "GPTAppDelegate.h"
#import "GPTSettings.h"
#import "GPTMainMenuViewController.h"
#import "UIViewController+AutoNibName.h"


@interface GPTInfoViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *emailTextField;
@property GPTSettings *settings;
@end

@implementation GPTInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!nibNameOrNil) {
        nibNameOrNil = [UIViewController autoNibName:@"GPTInfoViewController"];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) saveEmailTextField {
    if (self.emailTextField.text.length > 0) {
        self.settings.yourEmail = self.emailTextField.text;
        [self.settings saveSettings];
    }
}
- (IBAction)hideKeyboard:(UIButton *)sender {
    [self.emailTextField resignFirstResponder];
}

- (IBAction)emailTextFieldEditFinished:(UITextField *)sender {
    [self saveEmailTextField];
}

- (IBAction)buttonSexessoPressed:(UIButton *)sender {
    [self saveEmailTextField];
    [app changeRootViewController:VC_MAINMENU];
}
- (IBAction)visitSexesso:(UIButton *)sender {
    [self saveEmailTextField];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sexesso.com/news.html"]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.settings = [[GPTSettings alloc] init];
    if (self.settings.yourEmail && self.settings.yourEmail.length > 0) {
        self.emailTextField.text = self.settings.yourEmail;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEmailTextField:nil];
    [super viewDidUnload];
}
@end
