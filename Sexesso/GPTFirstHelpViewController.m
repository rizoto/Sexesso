//
//  GPTFirstHelpViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 16/09/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTFirstHelpViewController.h"
#import "GPTAppDelegate.h"
#import "game_def.h"    
#import "GPTMainMenuViewController.h"
#import "UIViewController+AutoNibName.h"

@interface GPTFirstHelpViewController ()

@end

@implementation GPTFirstHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!nibNameOrNil) {
        nibNameOrNil = [UIViewController autoNibName:@"GPTFirstHelpViewController"];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (IBAction)buttonSexessoPressed:(UIButton *)sender {
    [app changeRootViewController:VC_MAINMENU];
}

@end
