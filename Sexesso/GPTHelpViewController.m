//
//  GPTHelpViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 31/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTHelpViewController.h"
#import "game_def.h"
#import "GPTAppDelegate.h"
#import "GPTSettings.h"
#import "GPTMainMenuViewController.h"
#import "UIViewController+AutoNibName.h"

@interface GPTHelpViewController ()

@end

@implementation GPTHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!nibNameOrNil) {
        nibNameOrNil = [UIViewController autoNibName:@"GPTHelpViewController"];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)buttonSexessoPressed:(UIButton *)sender {
    [app changeRootViewController:VC_MAINMENU];
}

- (IBAction)visitSexesso:(UIButton *)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sexesso.com/contact.html"]];
}

- (IBAction)visitHelp:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sexesso.com/phone/how-to.html"]];
}

- (IBAction)visitHelpEasy:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sexesso.com/phone/how-to.html#easy"]];
}

- (IBAction)visitHelpHard:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sexesso.com/phone/how-to.html#hard"]];
}

- (IBAction)visitHelpCrazy:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.sexesso.com/phone/how-to.html#crazy"]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
