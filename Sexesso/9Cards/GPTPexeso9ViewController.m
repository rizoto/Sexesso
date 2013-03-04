//
//  GPTPexesoViewController.m
//  FlipFlop
//
//  Created by Lubor Kolacny on 31/01/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTPexeso9ViewController.h"
#import "GPTPexeso9Game.h"
#import "GPTPexeso9Cards.h"

#define BACKSIDESL  @"cardback.png"
#define CARDS       9
#define MATCH       2

@interface GPTPexeso9ViewController ()

@property (strong,nonatomic) GPTPexeso9Game* game;

@end

@implementation GPTPexeso9ViewController

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
    [self.game turnACard:(GPTPexeso9Card*)sender.view WithCompletionBlock:^(BOOL finished){
        if (((GPTPexeso9Card*)sender.view).bFaceSide) {
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

    self.game = [[GPTPexeso9Game alloc] initWithNumberOfCards:CARDS MatchCards:MATCH BackCardImage:@[@"card_back_150x200px-01.png",@"card_back_150x200px-02.png",@"card_back_150x200px-02.png",@"card_back_150x200px-01.png",@"card_back_150x200px-01.png",@"card_back_150x200px-02.png",@"card_back_150x200px-02.png",@"card_back_150x200px-01.png",@"card_back_150x200px-01.png"] FaceCardImage:@[@"card_face_150-200-01.png",@"card_face_150-200-02.png",@"card_face_150-200-03.png",@"card_face_150-200-04.png",@"card_face_150-200-01.png",@"card_face_150-200-02.png",@"card_face_150-200-03.png",@"card_face_150-200-04.png",@"card_face_150-200-05.png"] Controller:self];
    [self.game generateCards];
    CGRect r;
    r.origin.x = 30;
    r.origin.y = 30;
    r.size.height = 150;
    r.size.width = 20;
    [self.game matrixWith:3 By:3 With:75 And:100 AndWithFrame:r];

    
    //

}
- (IBAction)goBack:(UIButton *)sender {
    //    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
