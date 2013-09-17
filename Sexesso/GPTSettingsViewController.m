//
//  GPTSettingsViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 14/07/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTSettingsViewController.h"
#import "GPTAppDelegate.h"
#import "GPTMainMenuViewController.h"
#import "GPTPlayGameViewController.h"
#import "GPTSettings.h"
#import "game_def.h"
#import "UIViewController+AutoNibName.h"

@interface GPTSettingsViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *easyButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *hardButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *crazyButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *buttonVanessa;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *buttonAurora;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *notifyOnOffButton;

@property GPTSettings *settings;

@end

@implementation GPTSettingsViewController

// static int i = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!nibNameOrNil) {
        nibNameOrNil = [UIViewController autoNibName:@"GPTSettingsViewController"];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//
// go back to menu
// #import "GPTMainMenuViewController.h"
//
- (IBAction)menuButtonPressed:(UIButton *)sender {
    [((GPTAppDelegate*)[UIApplication sharedApplication].delegate) changeRootViewController:VC_MAINMENU];
}
- (IBAction)easySelected:(UIButton *)sender {
    self.easyButton.selected = YES;
    self.hardButton.selected = NO;
    self.crazyButton.selected = NO;
    self.settings.difficulty = EASY_GAME;
    [self.settings saveSettings];
    
}
- (IBAction)hardSelected:(UIButton *)sender {
    self.hardButton.selected = YES;
    self.easyButton.selected = NO;
    self.crazyButton.selected = NO;    
    self.settings.difficulty = HARD_GAME;
    [self.settings saveSettings];
}
- (IBAction)crazySelected:(UIButton *)sender {
    self.hardButton.selected = NO;
    self.easyButton.selected = NO;
    self.crazyButton.selected = YES;
    self.settings.difficulty = CRAZY_GAME;
    [self.settings saveSettings];
}

- (IBAction)collectionVanessaSelected:(UIButton *)sender {
    self.buttonAurora.selected = NO;
    self.buttonVanessa.selected = YES;
    self.settings.collection = COLLECTION1;
    [self.settings saveSettings];    
}
- (IBAction)collectionAuroraSelected:(UIButton *)sender {
    self.buttonAurora.selected = YES;
    self.buttonVanessa.selected = NO;
    self.settings.collection = COLLECTION2;
    [self.settings saveSettings];    
}
- (IBAction)newGame:(UIButton *)sender {
    if ([self allSetUp]) {
            [((GPTAppDelegate*)[UIApplication sharedApplication].delegate) changeRootViewController:VC_PLAYGAME];
    }

}
- (IBAction)notifyOnOff:(UIButton *)sender {
    
    // push notifications / alerts very often
    
    if (!self.notifyOnOffButton.selected) {
        self.notifyOnOffButton.selected = YES;
        self.settings.notifications = NOTIFY_ON;
        [self.settings saveSettings];        
    }
    else {
        self.notifyOnOffButton.selected = NO;
        self.settings.notifications = NOTIFY_OFF;
        [self.settings saveSettings];        
    }
    
}

// return if all necessary settings on
- (BOOL) allSetUp
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // setup model
    self.settings = [[GPTSettings alloc]init]; // TODO
    if (self.settings.difficulty == HARD_GAME) [self hardSelected:nil]; else if (self.settings.difficulty == CRAZY_GAME) [self crazySelected:nil]; else     [self easySelected:nil];
    
    if (self.settings.notifications == NOTIFY_ON) self.notifyOnOffButton.selected = YES; else self.notifyOnOffButton.selected = NO;
    if ([self.settings.collection isEqualToString:COLLECTION1]) [self collectionVanessaSelected:nil]; else [self collectionAuroraSelected:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dealloc
{

    
}

- (void)viewDidUnload {
    [self.settings saveSettings];
    [self setEasyButton:nil];
    [self setHardButton:nil];
    [self setButtonVanessa:nil];
    [self setButtonAurora:nil];
    [self setNotifyOnOffButton:nil];
    [self setCrazyButton:nil];
    [super viewDidUnload];
}
@end
