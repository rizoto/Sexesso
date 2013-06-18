//
//  GPTCheatViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 16/06/13.
//  Copyright (c) 2013 Green Plus Technology. All rights reserved.
//

#import "GPTCheatViewController.h"
#import "device_def.h"

@interface GPTCheatViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bgImg;

@end

@implementation GPTCheatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)tapToReturnBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (IS_IPHONE_5) {
        NSLog(@"Iphone5");
        self.bgImg.image = [UIImage imageNamed:@"ip5_vanessa.png"];
        CGRect s;
        s = self.bgImg.frame;
        s.size.height = 568.00;
        
        [self.bgImg setFrame:s];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBgImg:nil];
    [super viewDidUnload];
}
@end
