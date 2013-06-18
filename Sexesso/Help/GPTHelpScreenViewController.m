//
//  GPTHelpScreenViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 16/06/13.
//  Copyright (c) 2013 Green Plus Technology. All rights reserved.
//

#import "GPTHelpScreenViewController.h"
#import "device_def.h"

@interface GPTHelpScreenViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *backGroundImg;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *helpBackImg;

@end

@implementation GPTHelpScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)returnBack:(UITapGestureRecognizer *)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_IPHONE_5) {
        NSLog(@"Iphone5");
        self.backGroundImg.image = [UIImage imageNamed:@"ip5_help.png"];
        CGRect s;
        s = self.backGroundImg.frame;
        s.size.height = 568.00;
        [self.backGroundImg setFrame:s];
        
//        s = self.helpBackImg.frame;
//        s.origin.y += 88;
//        [self.helpBackImg setFrame:s];
        
  //      [self.view bringSubviewToFront:self.helpBackImg];
        
        
    }
    UIButton* back = [[UIButton alloc] initWithFrame:CGRectMake(284, (!IS_IPHONE_5)?444:524, 37, 37)];
    [back addTarget:self action:@selector(returnBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackGroundImg:nil];
    [self setHelpBackImg:nil];
    [super viewDidUnload];
}
@end
