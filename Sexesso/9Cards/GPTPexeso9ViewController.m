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
#import "device_def.h"

#define BACKSIDESL  @"cardback.png"
#define CARDS       9
#define MATCH       2



@interface GPTPexeso9ViewController ()

@property (strong,nonatomic) GPTPexeso9Game* game;
@property UIButton* back;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *backGroundImg;

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

//
// close a game and return to the menu
//

- (void)returnBack:(UITapGestureRecognizer *)sender {

    [self dismissModalViewControllerAnimated:YES];
}

//- (void)tap:(UITapGestureRecognizer *)sender {
//    NSLog(@".....tap....");
//   
//    if (sender.numberOfTouches > 0) { // tap screen -> turn a card
//        
//
//    }
//    if (!((GPTPexeso9Card*)sender.view).bFaceSide){ // face side, disable turning
//        [sender setEnabled:NO];
//        sender.enabled = NO;    
//        [sender.view setUserInteractionEnabled:NO]; }
//    [self.game turnACard:(GPTPexeso9Card*)sender.view WithCompletionBlock:^(BOOL finished){
//        if (((GPTPexeso9Card*)sender.view).bFaceSide) {
//            // turn it back
//            [self performSelector:@selector(tap:) withObject:sender afterDelay:3.5];
//             NSLog(@"--------------->");
//            [sender setEnabled:YES];
//            [sender.view setUserInteractionEnabled:YES];
//
//        }}];
//}

- (void) turnACardFromFaceToBackWithAnimation: (UITapGestureRecognizer *)sender
{
    [self.game turnACardFromFaceToBackWithAnimation:(GPTPexeso9Card*)sender.view];
    [sender setEnabled:YES];
}

- (void)tap2:(UITapGestureRecognizer *)sender {
 
    NSLog(@".....tap2....");
    
    [self.game turnACardFromBackToFaceWithAnimation:(GPTPexeso9Card*)sender.view];
    [sender setEnabled:NO]; // turned card can't be hit
                            // will turn back automatically
    [self performSelector:@selector(turnACardFromFaceToBackWithAnimation:) withObject:sender afterDelay:1.9];

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
    
    if (IS_IPHONE_5) {
        NSLog(@"Iphone5");
        self.backGroundImg.image = [UIImage imageNamed:@"IP5_blackbackground1136px.png"];
        CGRect s;
        s = self.backGroundImg.frame;
        s.size.height = 568.00;
        
        [self.backGroundImg setFrame:s];
        
    }
    

    self.game = [[GPTPexeso9Game alloc] initWithNumberOfCards:CARDS MatchCards:MATCH BackCardImage:@[@"card_back_150x200px-01.png",@"card_back_150x200px-02.png",@"card_back_150x200px-02.png",@"card_back_150x200px-01.png",@"card_back_150x200px-01.png",@"card_back_150x200px-02.png",@"card_back_150x200px-02.png",@"card_back_150x200px-01.png",@"card_back_150x200px-01.png"] FaceCardImage:@[@"card_face_150-200-01.png",@"card_face_150-200-02.png",@"card_face_150-200-03.png",@"card_face_150-200-04.png",@"card_face_150-200-01.png",@"card_face_150-200-02.png",@"card_face_150-200-03.png",@"card_face_150-200-04.png",@"card_face_150-200-05.png"] Controller:self];
    [self.game generateCards];
    CGRect r;
    r.origin.x = 30;
    r.origin.y = 30;
    r.size.height = 150;
    r.size.width = 20;
    [self.game matrixWith:3 By:3 With:75 And:100 AndWithFrame:r];
    
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(284, (!IS_IPHONE_5)?444:524, 37, 37)];
    [back addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    

    
    //

}
- (IBAction)goBack:(UIButton *)sender {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackGroundImg:nil];
    [super viewDidUnload];
}
@end
