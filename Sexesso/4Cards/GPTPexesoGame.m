//
//  GPTPexesoGame.m
//  FlipFlop
//
//  Created by Lubor Kolacny on 1/02/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//


#import "GPTPexesoGame.h"
#import "GPTPexesoCard.h"

@interface GPTPexesoGame()

@property NSMutableArray* cards;
@property UIViewController *controller;
@property int cardsInGame;
@property int matchCards;
@property BOOL allCardBlock;
@property int turnedCards;
@property NSArray* backCardImage;
@property NSArray* faceCardImage;
@property BOOL isMatched;

@property UIImageView *bigGirl;
@property UIImageView *smallGirl;
@property UIImageView *bigCard;

@end

CGRect _cardSize;

@implementation GPTPexesoGame

- (id) initWithNumberOfCards:(int)numberOfCards MatchCards: (int) match BackCardImage: (NSArray*) imageBack FaceCardImage: (NSArray*) imageFace Controller:(UIViewController*) vc
{
    if(imageBack.count < numberOfCards || imageFace.count < numberOfCards) assert(@"not enough cards");
    self = [super init];
    self.controller = vc;
    self.cardsInGame = numberOfCards;
    self.cards = [[NSMutableArray alloc] initWithCapacity:numberOfCards];
    self.turnedCards = 0;
    self.matchCards = match;
    self.backCardImage = imageBack;
    self.faceCardImage = imageFace;
    self.allCardBlock = NO;
    self.isMatched = NO;
    self.unmatchedCard = 0;
    UIImage *ui =  [UIImage imageNamed:imageBack[0]];
    _cardSize.size.height = ui.size.height;
    _cardSize.size.width = ui.size.width;
    
    return self;
    
}

- (void) generateCards
{
    for(int i = 0; i < self.cardsInGame; i++)
    {
        GPTPexesoCard *ui1 = [[GPTPexesoCard alloc] init];
        [ui1 setFrame:_cardSize];
        [ui1 setImage:[UIImage imageNamed:self.backCardImage[i]]];
        [ui1 setFaceCard:self.faceCardImage[i]];
        [ui1 setBackCard:self.backCardImage[i]];
        [self.cards insertObject:ui1 atIndex:i];
    }
}

- (BOOL)  areCardsMatching
{
    NSLog(@"matching?");
    NSString *firstTurned = nil;
    BOOL result = NO;
    for (GPTPexesoCard *g in self.cards) {
        // NSLog(@"%@,%@,%c",firstTurned,g.faceCard,g.bFaceSide);
        if(!firstTurned && (g.bFaceSide))
            firstTurned = g.faceCard;
        else{
            if(g.bFaceSide && [firstTurned isEqualToString:(g.faceCard)])
            {
                result = YES;
                NSLog(@"matching pair");}
        }
    }
    return result;
}

- (BOOL) isGameFinished
{
    int unpaired = 0;
    for (GPTPexesoCard *g in self.cards)
    {
        g.bFaceSide?unpaired++:0;
    }
    return unpaired == self.unmatchedCard;
}

- (void) finishGame
{
    self.smallGirl = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"large-girl-03.png"]];
    self.bigGirl = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"large-girl-03.png"]];
    self.bigCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"large-face-empty.png"]];
    // center big card
    CGRect r;
    r = self.bigCard.frame;
    r.origin.x = (self.controller.view.frame.size.width -  self.bigCard.frame.size.width) / 2.0;
    r.origin.y = (self.controller.view.frame.size.height -  self.bigCard.frame.size.height) / 2.0;
    [self.bigCard setFrame:r];
    // center big girl
    CGRect r1;
    r1 = self.bigGirl.frame;
    r1.origin.x = (self.controller.view.frame.size.width -  self.bigGirl.frame.size.width) / 2.0;
    r1.origin.y = (self.controller.view.frame.size.height -  self.bigGirl.frame.size.height) / 2.0;
    [self.bigGirl setFrame:r1];
    //small girl
    CGRect r2;
    r2 = self.smallGirl.frame;
    r2.origin.x = (self.controller.view.frame.size.width -  self.smallGirl.frame.size.width) / 2.0 + 150;
    r2.origin.y = (self.controller.view.frame.size.height -  self.smallGirl.frame.size.height) / 2.0 + 10;
    r2.size.width = r2.size.width / 3;
    r2.size.height = r2.size.height / 3;
    [self.smallGirl setContentMode:UIViewContentModeScaleToFill];
    [self.smallGirl setFrame:r2];
    
    // add tap guesture 
    UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self.controller action:@selector(returnBack:)];
    [self.bigCard addGestureRecognizer:t];
    t.delegate = (id)self.controller;
    [self.bigCard  setUserInteractionEnabled:YES];
    [self.bigCard setHidden:NO];
    [self.smallGirl setHidden:NO];
    [self.bigGirl setHidden:YES];
    [self.controller.view addSubview:self.bigCard];
    [self.controller.view addSubview:self.smallGirl];
    [self.controller.view addSubview:self.bigGirl];
    [self hideAllCards];
    NSLog(@"Show Girl!");

    [UIView animateWithDuration:2.0
                          delay:0.3
                        options: UIViewAnimationCurveEaseOut
                     animations:^{
                         
                         self.smallGirl.frame = self.bigGirl.frame;
                         self.smallGirl.alpha = self.bigGirl.alpha;
                         
                         
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Done!");
                         //                        [self.bigGirl setHidden:NO];
                         //                        [self.smallGirl setHidden:YES];
                         NSLog(@"Show Girl1!");
                         
                        
                         
                     }];
    
    
    
}

- (void) hideMatchingCards
{
    [self.cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (((GPTPexesoCard*)obj).bFaceSide) {
            [(GPTPexesoCard*)obj setHidden:YES];
            [(GPTPexesoCard*)obj setBFaceSide:NO];
            [self setIsMatched:NO];
    }
    }];
    
}

- (void) hideAllCards
{
    [self.cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [(GPTPexesoCard*)obj setHidden:YES];
    }];
}

- (BOOL) turnACard:(GPTPexesoCard*)card WithCompletionBlock: (void (^)(BOOL))block
{
        
    if (card.bFaceSide) {
        if(--self.turnedCards == 0) [self unBlockAllCards];
        if(self.turnedCards < 0) self.turnedCards = 0;
        if (self.isMatched && self.turnedCards == 0) [self hideMatchingCards];
        if ([self isGameFinished]) {
            [self finishGame];
        }
        if (self.isMatched) {
            return NO;
        }
    }
    else{
        if ((++self.turnedCards) >= self.matchCards) {

            [self blockAllCards];

            
        }
    }
    
    [UIView transitionWithView:card duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        UIImage *ui;
                        ui = [card image];
                        [card setImage:[UIImage imageNamed:card.bFaceSide?card.backCard:card.faceCard]];
                        card.bFaceSide = card.bFaceSide?NO:YES;
                        //card.bFaceSide?++self.turnedCards:--self.turnedCards;
                        NSLog(@"turned cards: %d", self.turnedCards);
                        if(self.turnedCards >= self.matchCards && [self areCardsMatching])
                        {
                            // find match, hide the cards
                            self.isMatched = YES;
                        }
                    }
                    completion:(void (^)(BOOL))block ];
    [self.cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"%@",((GPTPexesoCard*)obj).bFaceSide?@"YES":@"NO");
    }];
       
             
    return YES;
}

- (void) blockAllCards
{
    [self.cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(GPTPexesoCard*)obj setUserInteractionEnabled:NO];
    }];
    self.allCardBlock = YES;
}

- (void) unBlockAllCards
{
    [self.cards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(GPTPexesoCard*)obj setUserInteractionEnabled:YES];
    }];
    self.allCardBlock = NO;
}
- (void) matrixWith:(int) x By: (int) y With: (int) imageWidth And: (int) imageHeight AndWithFrame: (CGRect) frame
{
    if(x*y > self.cardsInGame) assert(@"error");
    if(x > 1) assert(@"error");
    if(y > 1) assert(@"error");
    CGRect r;
    // x1,y1 start of matrix top-left corner
    // xg - gap between cards
    // yg - gap
    //    NSLog(@"frame: %.2f,%.2f",self.view.frame.size.width, self.view.frame.size.height);
    int xg = (self.controller.view.frame.size.width - (x*imageWidth)-(frame.origin.x+frame.size.width)) / (x-1);
    int yg = (self.controller.view.frame.size.height - (y*imageWidth)-(frame.origin.y+frame.size.height)) / (y-1);
    //    NSLog(@"Gap %d,%d", xg, yg);
    int x1 = frame.origin.x;
    int y1 = frame.origin.y;
    int idx = 0;
    r.origin.x = x1;
    r.origin.y = y1;
    r.size.height = imageHeight;
    r.size.width = imageWidth;
    for (int i = 0; i < x; i++) {
        for (int j = 0; j < y; j++)
        {
            r.origin.x = x1 + i*(xg+imageWidth);
            r.origin.y = y1 + j*(yg+imageHeight);
            [self.cards[idx] setFrame:r];
            // add touches
            UITapGestureRecognizer *t = [[UITapGestureRecognizer alloc] initWithTarget:self.controller action:@selector(tap:)];
            [self.cards[idx] addGestureRecognizer:t];
            t.delegate = (id)self.controller;
            [(UIView*)self.cards[idx]  setUserInteractionEnabled:YES];
            // add to view
            [self.controller.view addSubview:self.cards[idx++]];
        }
    }
}



@end
