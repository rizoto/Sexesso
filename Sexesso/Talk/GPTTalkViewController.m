//
//  GPTTalkViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 17/06/13.
//  Copyright (c) 2013 Green Plus Technology. All rights reserved.
//

#import "GPTTalkViewController.h"
#import "device_def.h"

@interface GPTTalkViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bgImg;
@end

@implementation GPTTalkViewController

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
        self.bgImg.image = [UIImage imageNamed:@"IP5_chat-background-screen.png"];
        CGRect s;
        s = self.bgImg.frame;
        s.size.height = 568.00;
        
        [self.bgImg setFrame:s];
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
    [self setBgImg:nil];
    [super viewDidUnload];
}
@end
