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

@interface GPTViewController ()

@end

@implementation GPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // TODO - condition for the first time launch
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

@end
