//
//  GPTScoreViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 31/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTScoreViewController.h"
#import "game_def.h"
#import "GPTAppDelegate.h"
#import "GPTSettings.h"
#import "GPTMainMenuViewController.h"
#import "UIViewController+AutoNibName.h"
#import "GPTCollTimePair.h"

@interface GPTScoreViewController ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *scoreView;
@property GPTSettings *settings;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *scoreBoard;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bestTimeEasy;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bestTimeHard;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *bestTimeCrazy;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *scoreBoardTime;

@end

@implementation GPTScoreViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!nibNameOrNil) {
        nibNameOrNil = [UIViewController autoNibName:@"GPTScoreViewController"];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)buttonSexessoPressed:(UIButton *)sender {
    [app changeRootViewController:VC_MAINMENU];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.settings = [[GPTSettings alloc] init];
    NSString *difficulty;
    if (self.settings) {
        switch (self.settings.difficulty) {
            case EASY_GAME:
                difficulty = keyEasyGame;
                [self.scoreView setHidden:YES];
                [self.bestTimeCrazy setHidden:YES];
                [self.bestTimeHard setHidden:YES];
                [self.bestTimeEasy setHidden:NO];
                break;
            case HARD_GAME:
                difficulty = keyHardGame;
                [self.scoreView setHidden:YES];
                [self.bestTimeCrazy setHidden:YES];
                [self.bestTimeHard setHidden:NO];
                [self.bestTimeEasy setHidden:YES];
                break;
            case CRAZY_GAME:
                difficulty = keyCrazyGame;
                [self.scoreView setHidden:YES];
                [self.bestTimeCrazy setHidden:NO];
                [self.bestTimeHard setHidden:YES];
                [self.bestTimeEasy setHidden:YES];
                break;
            default:
                [self.scoreView setHidden:YES];
                [self.bestTimeCrazy setHidden:NO];
                [self.bestTimeHard setHidden:YES];
                [self.bestTimeEasy setHidden:YES];
                break;
        }
        // NSArray *score = [[self.settings.score objectForKey:self.settings.collection] objectForKey:difficulty];
        NSMutableArray *scoreCollection1 = [[self.settings.score objectForKey:COLLECTION1] objectForKey:difficulty];
        NSMutableArray *scoreCollection2 = [[self.settings.score objectForKey:COLLECTION2] objectForKey:difficulty];
        // GPTLog(@"%@",score);
        int i = 1;
        GPTCollTimePair *collTimePair = [[GPTCollTimePair alloc] init];
        collTimePair.time = MAX_GAME_LIMIT;
        collTimePair.collection = @"";
        for (UILabel *l in self.scoreBoard) {
            collTimePair = [self findBestTimeFromCollection:scoreCollection1 And:scoreCollection2 And:collTimePair];
            int seconds = collTimePair.time;
            //int seconds = [score[i++] intValue];
            //l.text = [NSString stringWithFormat:@"%d.%@ %2d'%02d\"",i++,collTimePair.collection, seconds/60,seconds%60];
            l.text = [NSString stringWithFormat:@"%d.%@",i,collTimePair.collection];
            ((UILabel*)self.scoreBoardTime[i-1]).text = [NSString stringWithFormat:@"%2d'%02d\"", seconds/60,seconds%60];
            i++;
        }
    }

}

- (GPTCollTimePair*) findBestTimeFromCollection: (NSMutableArray*)coll1 And: (NSMutableArray*) coll2 And: (GPTCollTimePair*) colTime {
    GPTCollTimePair *c =  [[GPTCollTimePair alloc]init];
    if ([coll1[0] intValue] < [coll2[0] intValue]) {
        c.collection = COLLECTION1;
        c.time = [coll1[0] intValue];
        [coll1 removeObjectAtIndex:0];
    } else if ([coll2[0] intValue] < [coll1[0] intValue]) {
        c.collection = COLLECTION2;
        c.time = [coll2[0] intValue];
        [coll2 removeObjectAtIndex:0];
    } else if ([coll2[0] intValue] == [coll1[0] intValue] && [colTime.collection isEqualToString:COLLECTION1]) {
        c.collection = COLLECTION2;
        c.time = [coll2[0] intValue];
        [coll2 removeObjectAtIndex:0];
    } else {
        c.collection = COLLECTION1;
        c.time = [coll1[0] intValue];
        [coll1 removeObjectAtIndex:0];
    }
    
    return c;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScoreView:nil];
    [self setScoreBoard:nil];
    [self setBestTimeEasy:nil];
    [self setBestTimeHard:nil];
    [self setBestTimeCrazy:nil];
    [self setScoreBoardTime:nil];
    [super viewDidUnload];
}
@end
