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

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_ ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )


#define HEIGHT_IPHONE_5 568
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5 )

@interface GPTViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *backGroundImg;

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
    if(1)
    {
        GPTPexesoViewController *pexeso = [[GPTPexesoViewController alloc] init];
        [self presentModalViewController:pexeso animated:NO];
    }
        
    

}
- (IBAction)play9CardsGame:(UIButton *)sender {
    
    GPTPexeso9ViewController *pexeso9 = [[GPTPexeso9ViewController alloc] init];
    [self presentModalViewController:pexeso9 animated:YES];
    
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
