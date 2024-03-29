//
//  GPTPexesoViewController.m
//  FlipFlop
//
//  Created by Lubor Kolacny on 31/01/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTPexesoViewController.h"
#import "GPTPexesoGame.h"
#import "GPTPexesoCard.h"

#define BACKSIDESL  @"cardback.png"
#define CARDS       4
#define MATCH       2

@interface GPTPexesoViewController ()

@property (strong,nonatomic) GPTPexesoGame* game;

@end

@implementation GPTPexesoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)returnBack:(UITapGestureRecognizer *)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tap:(UITapGestureRecognizer *)sender {
   
    if (sender.numberOfTouches > 0) { // tap screen -> turn a card
        

    }
    [sender setEnabled:YES];
    [self.game turnACard:(GPTPexesoCard*)sender.view WithCompletionBlock:^(BOOL finished){
        if (((GPTPexesoCard*)sender.view).bFaceSide) {
            [self performSelector:@selector(tap:) withObject:sender afterDelay:2.0];
            [sender setEnabled:YES];
        }}];
}

- (IBAction)blockCards:(UIButton *)sender {
    [self.game blockAllCards];
}
- (IBAction)unBlockAllCards:(UIButton *)sender {
    [self.game unBlockAllCards];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //- (id) initWithNumberOfCards:(int)numberOfCards BackCardImage: (NSArray*) imageBack FaceCardImage: (NSArray*) imageFace Controller:(UIViewController*) vc

    self.game = [[GPTPexesoGame alloc] initWithNumberOfCards:CARDS MatchCards:MATCH BackCardImage:@[@"card-back-230.png",@"card-back-230.png",@"card-back-230.png",@"card-back-230.png"] FaceCardImage:@[@"4cards_faces-02.png",@"4cards_faces-01.png",@"4cards_faces-03.png",@"4cards_faces-02.png"] Controller:self];
    [self.game generateCards];
    CGRect r;
    r.origin.x = 50;
    r.origin.y = 70;
    r.size.height = 170;
    r.size.width = 50;
    [self.game matrixWith:2 By:2 With:100 And:150 AndWithFrame:r];

    
    //

}
- (IBAction)goBack:(UIButton *)sender {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
