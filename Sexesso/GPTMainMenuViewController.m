//
//  GPTMainMenuViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 9/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "devices.h"
#import "GPTAppDelegate.h"
#import "GPTMainMenuViewController.h"
#import "GPTSettingsViewController.h"
#import "GPTPlayGameViewController.h"
#import "GPTInfoViewController.h"
#import "GPTHelpViewController.h"
#import "UIViewController+AutoNibName.h"

@interface GPTMainMenuViewController ()



@end

@implementation GPTMainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
//    if (!IS_IPHONE_IPOD_CLASSIC) {
//        self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    } else {
//        self = [super initWithNibName:@"GPTMainMenuViewController~Classic" bundle:nibBundleOrNil];
//    }
    if (!nibNameOrNil) {
        nibNameOrNil = [UIViewController autoNibName:@"GPTMainMenuViewController"];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//
// MENU - BUTTONS
//

- (IBAction)playButtonPressed:(UIButton *)sender {
    [((GPTAppDelegate*)[UIApplication sharedApplication].delegate) changeRootViewController:VC_PLAYGAME];
}

- (IBAction)settingsButtonPressed:(UIButton *)sender {
    [((GPTAppDelegate*)[UIApplication sharedApplication].delegate) changeRootViewController:VC_SETTINGS];
}

- (IBAction)infoButtonPressed:(UIButton *)sender {
    [((GPTAppDelegate*)[UIApplication sharedApplication].delegate) changeRootViewController:VC_INFO];
}

- (IBAction)helpButtonPressed:(UIButton *)sender {
    [((GPTAppDelegate*)[UIApplication sharedApplication].delegate) changeRootViewController:VC_HELP];
}

//
// MENU - END
//

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

- (void)viewDidUnload {

    [super viewDidUnload];
}
@end
