//
//  GPTViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 9/02/13.
//  Copyright (c) 2013 Green Plus Technology. All rights reserved.
//

#import "GPTViewController.h"
#import "GPTPexesoViewController.h"
#import "GPTPexeso9ViewController.h"
#import "GPTHelpScreenViewController.h"
#import "GPTCheatViewController.h"
#import "GPTTalkViewController.h"
#import "device_def.h"



@interface GPTViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *backGroundImg;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *playButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *talkButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *cheatButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *shareButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *payButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *helpButton;
@property (unsafe_unretained, nonatomic) UIImage *oldBgImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *shareComingSoon;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *payOverlayButton;


@end

@implementation GPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // TODO - condition for the first time launch
    if (IS_IPHONE_5) {
        NSLog(@"Iphone5");
        self.backGroundImg.image = [UIImage imageNamed:@"IP5_menu_background_1136px.png"];
        CGRect s;
        s = self.backGroundImg.frame;
        s.size.height = 568.00;
        
        [self.backGroundImg setFrame:s];
    }
    // TODO
    
    // reverse background
    
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(284, (!IS_IPHONE_5)?444:524, 37, 37)];
    [back addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    // oldBgImage has to be nil
    self.oldBgImage = nil;
    
    self.shareComingSoon.hidden = true;
    self.payOverlayButton.hidden = true;
    
    // run only first time
    
    if(1)
    {
        GPTHelpScreenViewController *help = [[GPTHelpScreenViewController alloc] init];
        [self presentModalViewController:help animated:YES];
        
 //       GPTPexesoViewController *pexeso = [[GPTPexesoViewController alloc] init];
 //       [self presentModalViewController:pexeso animated:NO];
    }
        
    

}

- (void) changeBackgroundImage: (NSString *) image
{
    if ([image isEqualToString:@""])
    {
        // put old bg back
        self.backGroundImg.image = self.oldBgImage;
        self.oldBgImage = nil;
    }
    else
    {
        self.oldBgImage = self.backGroundImg.image;
        self.backGroundImg.image = [UIImage imageNamed:image];
        if (IS_IPHONE_5) {
            NSLog(@"Iphone5");
            CGRect s;
            s = self.backGroundImg.frame;
            s.size.height = 568.00;
            
            [self.backGroundImg setFrame:s];
        }
    }
}

// hide all buttons

- (void) hideAllButtons {
    
    self.playButton.hidden = true;
    self.talkButton.hidden = true;
    self.cheatButton.hidden = true;
    self.shareButton.hidden = true;
    self.payButton.hidden = true;
    self.helpButton.hidden = true;    
}

- (void) unHideAllButtons {
    
    self.playButton.hidden = false;
    self.talkButton.hidden = false;
    self.cheatButton.hidden = false;
    self.shareButton.hidden = false;
    self.payButton.hidden = false;
    self.helpButton.hidden = false;
    
}

// show overlay
- (void) showShareOverlay
{
    self.shareComingSoon.hidden = false;
}

- (void) hideShareOverlay
{
    self.shareComingSoon.hidden = true;
}

// show overlay
- (void) showPayOverlay
{
    self.payOverlayButton.hidden = false;
}

- (void) hidePayOverlay
{
    self.payOverlayButton.hidden = true;
}

// 9 cards game
- (IBAction)play9CardsGame:(UIButton *)sender {
    
    GPTPexeso9ViewController *pexeso9 = [[GPTPexeso9ViewController alloc] init];
    [self presentModalViewController:pexeso9 animated:YES];
    
}

// return back to menu
- (void)returnBack:(UITapGestureRecognizer *)sender {
    
 //   [self dismissModalViewControllerAnimated:YES];
    
    // empty string means, put old background image back
    if (self.oldBgImage){
        [self changeBackgroundImage:@""];
        [self unHideAllButtons];
        self.oldBgImage = nil;
    }
    [self hideShareOverlay];
    [self hidePayOverlay];
    [self unHideAllButtons];
    
}
- (IBAction)openSexessoWeb:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sexesso.com"]];;
}

- (IBAction)talkToMe:(UIButton *)sender {
    GPTTalkViewController *talk = [[GPTTalkViewController alloc] init];
    [self presentModalViewController:talk animated:YES];
    
}
- (IBAction)cheatOnMe:(id)sender {
    GPTCheatViewController *cheat = [[GPTCheatViewController alloc] init];
    [self presentModalViewController:cheat animated:YES];
}
- (IBAction)shareMe:(UIButton *)sender {
    
    [self hideAllButtons];
    [self showShareOverlay];
    
}
- (IBAction)payMe:(UIButton *)sender {
    
    [self hideAllButtons];
    [self showPayOverlay];
    
}

// help view controler
- (IBAction)helpMeAndAbout:(UIButton *)sender {
    GPTHelpScreenViewController *help = [[GPTHelpScreenViewController alloc] init];
    [self presentModalViewController:help animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackGroundImg:nil];
    [self setPlayButton:nil];
    [self setTalkButton:nil];
    [self setCheatButton:nil];
    [self setShareButton:nil];
    [self setPayButton:nil];
    [self setHelpButton:nil];
    [self setShareComingSoon:nil];
    [self setPayOverlayButton:nil];
    [super viewDidUnload];
}
@end
