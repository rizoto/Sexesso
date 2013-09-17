//
//  GPTPlayGameViewController.m
//  Sexesso
//
//  Created by Lubor Kolacny on 10/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTPlayGameViewController.h"
#import "GPTMainMenuViewController.h"
#import "GPTAppDelegate.h"
#import "GPTCard.h"
#import "GPTCardGame.h"
#import "game_def.h"
#import "GPTSettings.h"
#import "GPTScoreViewController.h"
#import "UIViewController+AutoNibName.h"

@interface GPTPlayGameViewController ()

@property GPTCardGame       *game;
@property NSTimeInterval    globalTimer; //managing all animations
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelPair;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelTimer;
//@property NSTimer *timer; //replace with timer from AppDelegate
@property long seconds;
@property BOOL isAnimating;
@property GPTCard *firstCard;
@property GPTCard *secondCard;
@property int matched;
@property GPTSettings *settings;
@property int timeLimit;
@property float timeMove;
@property char gameDifficulty;
@property NSMutableArray *removedCards;
@property int gameStatus;  // running,cancelled
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *positionPoint;


- (void) stopTimer;
-(void) startGameWithTimerAndInteractionEnabled;



@end

@implementation GPTPlayGameViewController

// start game block (forcing)
// used in swapCards

void(^startGameBlock)(GPTPlayGameViewController*)  = ^(GPTPlayGameViewController* c) {
    [c stopTimer];// timer is not running, game is off
    c.gameStatus = gameRunning;
    [c startGameWithTimerAndInteractionEnabled];
};

void(^middleGameBlock)(GPTPlayGameViewController*)  = ^(GPTPlayGameViewController* c) {
    c.gameStatus = gameRunning;
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
};

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!nibNameOrNil) {
        nibNameOrNil = [UIViewController autoNibName:@"GPTPlayGameViewController"];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//
// game time limit & difficulty
//
- (long) gameTimeLimit {
    switch (self.settings.difficulty) {
        case EASY_GAME:
            return EASY_GAME_LIMIT;
            break;
        case HARD_GAME:
            return HARD_GAME_LIMIT;
            break;
        case CRAZY_GAME:
            return CRAZY_GAME_LIMIT;
            break;
        default:
            return EASY_GAME_LIMIT;
            break;
    }
}

- (int) gameDifficulties {
    switch (self.settings.difficulty) {
        case EASY_GAME:
            return EASY_GAME;
            break;
        case HARD_GAME:
            return HARD_GAME;
            break;
        case CRAZY_GAME:
            return CRAZY_GAME;
            break;
        default:
            return EASY_GAME;
            break;
    }
}

- (NSString*) gameDifficultyKey {
    switch (self.settings.difficulty) {
        case EASY_GAME:
            return keyEasyGame;
            break;
        case HARD_GAME:
            return keyHardGame;
            break;
        case CRAZY_GAME:
            return keyCrazyGame;
            break;
        default:
            return keyEasyGame;
            break;
    }
}

//
// create a new game
//
- (void) createAndStartGame
{
    // init game
    self.game = [[GPTCardGame alloc] init];
    if (self.game) {
        // do other stuff
        
        // init models
        self.matched = 0;
        self.settings = [[GPTSettings alloc]init];
        self.timeLimit = [self gameTimeLimit];
        self.gameDifficulty = [self gameDifficulties];
        self.timeMove = TI_MOVE_DURATION * ((float)EASY_GAME_LIMIT/(float)self.timeLimit);
        // init animations time interval;
        self.globalTimer = 0.0;
        // disable user interaction before game start + timer
        self.isAnimating = YES;
        GPTLog1(@"self.isAnimating = YES");
        self.gameStatus = gamePaused; //status paused till it's really running
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        // set up cards
        [self.game loadAndInitCardsWithCollection:self.settings.collection]; // no animation yet
        [self addGameToViewStartingPosition]; // no animation
        [self moveCardsToPositionAndFlipAndShuffle]; // and turn them FaceDown
        self.removedCards = [NSMutableArray arrayWithCapacity:CARDS_IN_GAME];
        //
    } else {
        // error creating a game
        GPTLog(@"Create and Start Game failed!");
    }
    
}


//
// shuffle cards
// create an array and swap cards with animation
-(void) shuffle
{
    [self shuffle:NULL];
}

-(void) shuffle: (void(^)(GPTPlayGameViewController*))block
{
    NSMutableArray *swapCards;
    int shuffle = (self.game.cardCollection.count==CARDS_IN_GAME)?SHUFFLE:self.game.cardCollection.count;
    if (self.gameDifficulty == CRAZY_GAME) {
        // shuffle the whole collection
        shuffle = CARDS_IN_GAME * 2;
    }
    // Shuffle cards
    srandom( time( NULL ) );
    int swapA, swapB, swapAA, swapBB;
    self.globalTimer = 0.0;
    swapAA = -1;
    swapBB = -1;
    swapCards = [[NSMutableArray alloc]initWithCapacity:2*shuffle];
    for (int i=0; i<2*shuffle;) {        
        swapA = (random() % self.game.cardCollection.count);
        swapB = (random() % self.game.cardCollection.count);
        // GPTLog(@"%d,%d",swapA,swapB);
        if (swapB != swapA) {
            swapCards[i++] = [NSNumber numberWithInt:swapA];
            swapCards[i++] = [NSNumber numberWithInt:swapB];
        }
    }
    self.globalTimer = TI_MOVE_DURATION;
    if (swapCards.count >= 2) [self swapCardsWithArray:swapCards AndStartGameBlock:block]; else {
        GPTLog1(@"self.isAnimating = NO");
        self.isAnimating = NO;
    }
}

// swap cards crawling through array

-(void) swapCardsWithArray:(NSMutableArray*) cards AndStartGameBlock:(void(^)(GPTPlayGameViewController*))block
{
    GPTCard    *c1,*c2;
    CGRect frame1, frame2;
    c1 = self.game.cardCollection[[cards[0] intValue]];
    c2 = self.game.cardCollection[[cards[1] intValue]];
    frame1 = c1.frame;
    frame2 = c2.frame;
    [UIView animateWithDuration:self.timeMove
                              delay: self.globalTimer
                            options:UIViewAnimationOptionCurveLinear
                         animations: ^{
                             c1.frame = frame2;
                             c2.frame = frame1;
                         }
                     completion:^(BOOL finished){
                         [cards removeObjectAtIndex:0];
                         [cards removeObjectAtIndex:0];
                         self.globalTimer = TI_MOVE_DELAY;
                         if (cards.count >= 2) {
                             [self swapCardsWithArray:cards AndStartGameBlock:block];
                         } else {
                             // game initialization finished, run block
                             GPTLog(@"NSTimer %@",app.singeltonGameTimer);
                             if (block) {
                                block(self); // call block with controller
                             }
                             // all cards swapped and you can play
                             GPTLog1(@"self.isAnimating = NO");
                             self.isAnimating = NO;
                         }
                     }];
    
}

//
// start game when all animations finished, setup counter
//
-(void) startGameWithTimerAndInteractionEnabled
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [self.labelPair setHidden:NO]; //unhide it
    [self.labelTimer setHidden:NO];
    //invalidate timer if exists;
    //self.isAnimating = NO;
    self.seconds = 0;     
    if (self.gameStatus == gameRunning)
        app.singeltonGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    
}

-(void) updateTimer:(NSTimer *)t
{
    self.seconds++;
    GPTLog(@"NStimer %@, %ld",t,self.seconds);
    NSString *stringSeconds = [NSString stringWithFormat:@"%2d'%02d\"%c",(int)self.seconds/60,(int)self.seconds%60,self.gameDifficulty];
    self.labelTimer.text = stringSeconds;
    if (self.seconds >= self.timeLimit) {
        // game over, time limit
        [self stopTimer];
        self.isAnimating = YES;
        GPTLog1(@"self.isAnimating = YES");
        [self gameOver];
    }
}

- (void) gameOver
{
    NSString *title = @"Sorry!";
    NSString *message = [NSString stringWithFormat:@"Your time with %@ ran out!",self.settings.collection];
    UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:title message:message  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    uiAlert.tag = alertViewGameOver;
    [uiAlert show];
    
}

//
// flip card with animation + with completion block
//
-(void) flipCard:(GPTCard*) card
{
    [self flipCard:card WithBlock:NULL];
    
}
-(void) flipCard:(GPTCard*) card WithBlock: (void(^)(BOOL))block
{
    [UIView transitionWithView:card
                      duration:TI_FLIP_CARD
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [card flip];
                    }
                    completion:block];
}



//
// add cards to view
//
- (void) flipCards
{
    int i = 0;
    GPTCard *c;
    for (i = 0; i < CARDS_IN_GAME; i++) {
        c = ((GPTCard*)self.game.cardCollection[i]);
        [self flipCard:c];
    }
    
}

//
// move cards to position
//
- (void) moveCardsToPositionAndFlipAndShuffle
{
    int x,y,i;
    int x1,y1;
    int card_height;
    int card_width;
    x1 = self.positionPoint.frame.origin.x; // starting point
    y1 = self.positionPoint.frame.origin.y;
    int d = 8; // distance between cards
    i = 0;
    card_height = ((GPTCard*)self.game.cardCollection[0]).OriginFrame.size.height;
    card_width = ((GPTCard*)self.game.cardCollection[0]).OriginFrame.size.width;
    x1 = x1 - card_width/2;
    y1 = y1 - card_height/2;
    GPTCard *c;
    // NSTimeInterval timeDelay = 0.0;
    CGRect position;
    for (i = 0; i < CARDS_IN_GAME; i++) {
        c = ((GPTCard*)self.game.cardCollection[i]);
        x = x1 + (card_width+d) * (i%3);
        y = y1 + (card_height+d) * (i/3);
        
        // new card position
        // [c setCenter:CGPointMake(x, y)];
        
        
        // add card to playing board
        //[self.view addSubview:c];
        position = CGRectMake(x, y, card_width, card_height);
        [UIView animateWithDuration:TI_MOVE_DURATION
                              delay:self.globalTimer
                            options:UIViewAnimationOptionCurveLinear
                         animations: ^{
                             c.frame = position;
                         }
                         completion:^(BOOL finished){if(i==CARDS_IN_GAME-1){[self flipCards];[self shuffle:startGameBlock];}}];//[self flipCards];
        self.globalTimer += TI_MOVE_DELAY;
    }
    
}

//
// add cards to view to starting position
//
- (void) addGameToViewStartingPosition
{
    int x,y,i;
    int x1,y1;
    int card_height;
    int card_width;
    x1 = 0; // starting point
    y1 = 0;
    int d = 0; // distance between cards
    i = 0;
    card_height = ((GPTCard*)self.game.cardCollection[0]).SmallFrame.size.height;
    card_width = ((GPTCard*)self.game.cardCollection[0]).SmallFrame.size.width;
    GPTCard *c;
    for (i = 0; i < CARDS_IN_GAME; i++) {
        c = ((GPTCard*)self.game.cardCollection[i]);
        [c setFrame:c.SmallFrame];
        x = x1 + (card_width+d) * (i);
        y = y1 + (card_height/2);
        
        // position a card
        [c setCenter:CGPointMake(x, y)];
        
        // Configure gesture recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(handletap:)];
        tap.numberOfTapsRequired = 1;
        
        [c addGestureRecognizer:tap];
        
        // add card to playing board
        [self.view addSubview:c];
    }
    
}

//
// handle taps and game
//
- (void)handletap:(UIGestureRecognizer *)gestureRecognizer
{
    // return if animation
    GPTLog(@"Animating %c", self.isAnimating);
    if (self.isAnimating) {
        return;
    }
    GPTCard *c = (GPTCard*) gestureRecognizer.view;
    if (c == nil) {
        return;
    }
    // [self flipCard:c];
    // if a card has already been tapped?
    if (self.firstCard == nil) {
        // first card
        [self flipCard:c];
        self.firstCard = c;
        if ((int)c.cardValue.intValue == 0) {
            // Joker
            self.isAnimating = YES;
            GPTLog1(@"self.isAnimating = YES");
            [self performSelector:@selector(joker) withObject:nil afterDelay:TI_FLIP_UNMATCH];
        }
    } else if (c != self.firstCard) {
        //stop animation and turn second card
        self.isAnimating = YES;
        GPTLog1(@"self.isAnimating = YES");
        [self flipCard:c];
        self.secondCard = c;
        // are they a match?
        if (self.firstCard.cardValue == self.secondCard.cardValue) {
            // remove cards
            self.labelPair.text = [NSString stringWithFormat:@"%1d",++self.matched];
            [self removeMatchedCardsFromGame];
        } else {
            // flip both back
            if ((int)c.cardValue.intValue == 0) {
                // Joker
                [self performSelector:@selector(joker) withObject:nil afterDelay:TI_FLIP_UNMATCH];
            } else {
                [self performSelector:@selector(flipUnMatchedCardsBack) withObject:nil afterDelay:TI_FLIP_UNMATCH];
            }
        }
        
    }
}

//
// choose message when game finished
//
- (NSArray*) mergeScoreCollection1: (NSArray*) scoreCol1 WithScoreCollection2: (NSArray*) scoreCol2 {
    NSMutableSet *scoreUniqueValues = [NSMutableSet setWithSet:[NSSet setWithArray:scoreCol1]];
    [scoreUniqueValues addObjectsFromArray:scoreCol2];
    NSMutableArray *score = [NSMutableArray arrayWithArray:[scoreUniqueValues allObjects]];
    // sort the array with unique values
    [score sortUsingComparator:^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    // return it
    return score;
}

- (void) chooseAndShowMessage {
    srandom( time( NULL ) );
    NSArray *score = [[self.settings.score objectForKey:self.settings.collection] objectForKey:[self gameDifficultyKey]];
    NSArray *scoreCollection1 = [[self.settings.score objectForKey:self.settings.collection] objectForKey:[self gameDifficultyKey]];
    NSArray *scoreCollection2 = [[self.settings.score objectForKey:self.settings.collection] objectForKey:[self gameDifficultyKey]];
    NSString *title; NSString *message;
    NSArray *uniqueScoreValues = [self mergeScoreCollection1:scoreCollection1 WithScoreCollection2:scoreCollection2];
    
    NSString *stringSeconds = [NSString stringWithFormat:@"%2d'%02d\"",(int)self.seconds/60,(int)self.seconds%60];
    
    GPTLog(@"Unique Values: %@",uniqueScoreValues);
    
    if (self.seconds < [uniqueScoreValues[0] intValue] && [uniqueScoreValues[0] intValue] == MAX_GAME_LIMIT) {
        // first time
        title = @"Congratulations!";
        message = [NSString stringWithFormat:@"Your first score for this level is with %@ in %@.",self.settings.collection ,stringSeconds];
    } else if (self.seconds < [uniqueScoreValues[0] intValue]) {
        // beat time over all collections      
        NSArray *titles = @[@"Top Score!",@"You Champion!",@"Congratulations!"];
        NSArray *messages = @[@"Your best is with %@ in %@.",@"Awesome score with %@ in %@.",@"Your top score is with %@ in %@"];
        int i = random() % 3;
        title = titles[i];
        message = [NSString stringWithFormat:messages[i],self.settings.collection ,stringSeconds];
    } else if (self.seconds < [uniqueScoreValues[uniqueScoreValues.count<3?uniqueScoreValues.count-1:2] intValue]) {
        //beat top 3
        NSArray *titles = @[@"Getting there!",@"You are working it!",@"Keep going!"];
        NSArray *messages = @[@"Try and do better with %@ than %@.",@"You have finished %@ in %@!",@"Practice with %@ in less than %@."];
        int i = random() % 3;
        title = titles[i];
        message = [NSString stringWithFormat:messages[i],self.settings.collection ,stringSeconds];
    } else if (self.seconds < [score[uniqueScoreValues.count<5?uniqueScoreValues.count-1:5] intValue]) {
        //beat top 5
        NSArray *titles = @[@"You are ok!",@"Not too bad!",@"Timing is everything!"];
        NSArray *messages = @[@"You may need to play more with %@.",@"Work on your performance with %@",@"Go faster with %@."];
        int i = random() % 3;
        title = titles[i];
        message = [NSString stringWithFormat:messages[i],self.settings.collection];
    } else {
        NSArray *titles = @[@"Hmmm….",@"For real?"];
        NSArray *messages = @[@"Need more practise with %@.",@"%@ is embarrassed to save your score!"];
        int i = random() % 2;
        title = titles[i];
        message = [NSString stringWithFormat:messages[i],self.settings.collection];
    }
    UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:title message:message  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save Score", nil];
    uiAlert.tag = alertViewJokerFinishGame;
    [uiAlert show];
}

//
// joker handling, shuffle or end of game
//
- (void) joker
{
    GPTLog(@"Joker");
    if (self.game.cardCollection.count == 1) {
        // end of the game, you time is
        [self stopTimer];
        [self chooseAndShowMessage];
        
    } else {
        //[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self flipUnMatchedCardsBack];
        if (self.gameDifficulty == HARD_GAME && self.removedCards.count >= 2) {
            self.secondCard = (GPTCard*)self.removedCards.lastObject;
            [self.game.cardCollection addObject:self.secondCard];
            [self flipCard:self.secondCard];
            [self.removedCards removeLastObject];
            self.firstCard = (GPTCard*)self.removedCards.lastObject;
            [self flipCard:self.firstCard];
            [self.game.cardCollection addObject:self.firstCard];
            [self.removedCards removeLastObject];
            [self addRemovedCardsBack];
        } else if (self.gameDifficulty == CRAZY_GAME && self.removedCards.count >= 2) {
            [self addAllRemovedCardsBack];
        
        }
        self.isAnimating = YES;
        GPTLog1(@"self.isAnimating = YES");
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self shuffle:middleGameBlock]; //middle of game
    }
}
//
// flip both cards back (no match)
//
- (void) flipUnMatchedCardsBack
{
    if (self.firstCard) [self flipCard:self.firstCard];
    if (self.secondCard)[self flipCard:self.secondCard WithBlock:^(BOOL finished){self.isAnimating = NO;GPTLog1(@"self.isAnimating = NO");}];
    self.firstCard = nil;
    self.secondCard = nil;
}

//
// remove cards from game
//
- (void) removeMatchedCardsFromGame
{
    [UIView animateWithDuration:TI_REMOVE_DURATION delay:TI_REMOVE_DELAY
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.firstCard.alpha = 0;
                         self.secondCard.alpha=0;
                     }
                     completion:^(BOOL finished) {
                         [self.firstCard removeFromSuperview];
                         [self.secondCard removeFromSuperview];
                         // remove from game
                         [self.removedCards addObject:self.firstCard];
                         [self.removedCards addObject:self.secondCard];
                         [self.game.cardCollection removeObject:self.firstCard];
                         [self.game.cardCollection removeObject:self.secondCard];
                         //GPTLog(@"in collection %d",[self.game.cardCollection count]);
                         // Stop ignoring taps because animation is done
                         self.isAnimating = NO;
                         GPTLog1(@"self.isAnimating = NO");
                         self.firstCard = nil;
                         self.secondCard = nil;
                     }
     ];
}
//
// remove cards from game
//
- (void) addRemovedCardsBack
{
    [UIView animateWithDuration:TI_REMOVE_DURATION delay:TI_REMOVE_DELAY
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.firstCard.alpha = 1;
                         self.secondCard.alpha=1;
                     }
                     completion:^(BOOL finished) {
                         [self.view addSubview:self.firstCard];
                         [self.view addSubview:self.secondCard];
                         self.labelPair.text = [NSString stringWithFormat:@"%1d",--self.matched];
                         //GPTLog(@"in collection %d",[self.game.cardCollection count]);
                         // Stop ignoring taps because animation is done
                         self.isAnimating = NO;
                         GPTLog1(@"self.isAnimating = NO");
                         self.firstCard = nil;
                         self.secondCard = nil;
                     }
     ];
}
- (void) addAllRemovedCardsBack {
    // flip them back
    //for (GPTCard *c in self.removedCards) {
    //    [self flipCard:c];
    //}
    [UIView animateWithDuration:TI_REMOVE_DURATION delay:TI_REMOVE_DELAY
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         for (GPTCard *c in self.removedCards) {
                             c.alpha = 1;
                             [self flipCard:c];
                             [self.game.cardCollection addObject:c];
                             [self.view addSubview:c];
                         }
                     }
                     completion:^(BOOL finished) {
                         //for (GPTCard *c in self.removedCards) {
                         //    [self.game.cardCollection addObject:c];
                         //    [self.view addSubview:c];
                         //}
                         //GPTLog(@"in collection %d",[self.game.cardCollection count]);
                         // Stop ignoring taps because animation is done
                         self.isAnimating = NO;
                         GPTLog1(@"self.isAnimating = NO");
                         [self.removedCards removeAllObjects];
                         self.matched = 0;
                         self.labelPair.text = [NSString stringWithFormat:@"%1d",self.matched];
                     }
     ];
    
}
//
// go back to menu
//
- (IBAction)buttonSexessoPressed:(UIButton *)sender {
    //[self.timer invalidate];
    [self pauseTimer]; // pause
    NSString *title = @"For Sure?";
    NSString *message = [NSString stringWithFormat:@"Cancel game and return to menu?"];
    UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:title message:message  delegate:self cancelButtonTitle:@"Quit" otherButtonTitles:@"Resume", nil];
    [uiAlert show];
    uiAlert.tag = alertViewLeaveGame;
    //[((GPTAppDelegate*)[UIApplication sharedApplication].delegate) changeRootViewController:VC_MAINMENU];
}

- (IBAction)buttonNewGamePressed:(UIButton *)sender {
    [self pauseTimer]; // pause
    NSString *title = @"For Sure?";
    NSString *message = [NSString stringWithFormat:@"End game and start new?"];
    UIAlertView *uiAlert = [[UIAlertView alloc] initWithTitle:title message:message  delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:@"New Game", nil];
    [uiAlert show];
    uiAlert.tag = alertViewNewGame;
}

//
// Alert View handling
//

- (void)alertViewCancel:(UIAlertView *)alertView {
    GPTLog(@"alertViewCancel");
    [self stopTimer];
    [app changeRootViewController:VC_MAINMENU];    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    GPTLog(@"clickedButtonAtIndex");
    switch (alertView.tag) {
        case alertViewNewGame:
            if (alertView.firstOtherButtonIndex == buttonIndex) {
                // resume pressed
                GPTLog(@"New Game");
                [self stopTimer];
                [app changeRootViewController:VC_PLAYGAME];
            } else {
                // all other handle as continue and resume timer
                [self resumeTimer];
            }
            ;
            break;
        case alertViewLeaveGame: //Sexesso button pressed
            if (alertView.firstOtherButtonIndex == buttonIndex) {
                // resume pressed
                GPTLog(@"Resume");
                [self resumeTimer];
            } else {
                // all other handle as cancel
                [self stopTimer];
                [app changeRootViewController:VC_MAINMENU];
            }
            break;
        case alertViewGameOver:
            [self stopTimer];
            [app changeRootViewController:VC_MAINMENU];
            break;
        case alertViewJokerFinishGame:
            if (alertView.firstOtherButtonIndex == buttonIndex) {
                // resume pressed
                GPTLog(@"Save");
                [self saveScore];
            } else {
                // all others handle as cancel
                [self stopTimer];
                [app changeRootViewController:VC_MAINMENU];
            }
            break;
        default:
            [self stopTimer];
            [app changeRootViewController:VC_MAINMENU];
            break;
    }
}

- (void) saveScore {
    GPTLog(@"Save Score");
    NSMutableDictionary *d = [self.settings.score objectForKey:self.settings.collection];
    NSString *s;
    switch (self.settings.difficulty) {
        case EASY_GAME:
            s = keyEasyGame;
            break;
        case HARD_GAME:
            s = keyHardGame;
            break;
        case CRAZY_GAME:
            s = keyCrazyGame;
            break;
        default:
            s = keyEasyGame;
            break;
    }
    NSMutableArray *a1 = [NSMutableArray arrayWithArray:[d objectForKey:s]];
    for(int i = 0; i < a1.count; i++) {
        if ([(NSNumber*)a1[i] longValue] >= self.seconds) {
            if ([(NSNumber*)a1[i] longValue] != self.seconds) {
                [a1 insertObject:[NSNumber numberWithLong:self.seconds] atIndex:i];
                [a1 removeLastObject];
            }
            i = a1.count + 1; // go away
        }
    }
    if ([self.settings.collection isEqualToString:COLLECTION1]) {
        self.settings.gamesColl1Played++;
    } else {
        self.settings.gamesColl2Played++;
    }
    [d setObject:a1 forKey:s];
    GPTLog(@"D - Score %@", d);
    [self.settings saveSettings];
    [app changeRootViewController:VC_SCORE];
}

//
// handle timer
//

- (void) stopTimer {    
    [self pauseTimer];
    self.gameStatus = gameCancelled;
}

- (void) pauseTimer {
    if (app.singeltonGameTimer) {
        [app.singeltonGameTimer invalidate];
        app.singeltonGameTimer = nil;
    }
    self.gameStatus = gamePaused;
}

- (void) resumeTimer {
    if (self.gameStatus != gameCancelled) {
        if (!app.singeltonGameTimer)
            app.singeltonGameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
        self.gameStatus = gameRunning;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createAndStartGame];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLabelPair:nil];
    [self setLabelTimer:nil];
    [self setPositionPoint:nil];
    [super viewDidUnload];
}
@end
