//
//  GPTPexesoGame.h
//  FlipFlop
//
//  Created by Lubor Kolacny on 1/02/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPTPexesoCard.h"

@interface GPTPexesoGame : NSObject

@property int unmatchedCard;

- (id) initWithNumberOfCards:(int)numberOfCards MatchCards: (int) match BackCardImage: (NSArray*) imageBack FaceCardImage: (NSArray*) imageFace Controller:(UIViewController*) vc;
- (void) matrixWith:(int) x By: (int) y With: (int) imageWidth And: (int) imageHeight AndWithFrame: (CGRect) frame;
- (void) generateCards;
- (void) blockAllCards;
- (void) unBlockAllCards;

- (BOOL) turnACard:(GPTPexesoCard*) card WithCompletionBlock: (void (^)(BOOL))block;

@end
