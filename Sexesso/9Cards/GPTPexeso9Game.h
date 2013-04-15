//
//  GPTPexesoGame.h
//  FlipFlop
//
//  Created by Lubor Kolacny on 1/02/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPTPexeso9Cards.h"

@interface GPTPexeso9Game : NSObject

@property int unmatchedCard;

- (id) initWithNumberOfCards:(int)numberOfCards MatchCards: (int) match BackCardImage: (NSArray*) imageBack FaceCardImage: (NSArray*) imageFace Controller:(UIViewController*) vc;
- (void) matrixWith:(int) x By: (int) y With: (int) imageWidth And: (int) imageHeight AndWithFrame: (CGRect) frame;
- (void) generateCards;
- (void) blockAllCards;
- (void) unBlockAllCards;

- (BOOL) turnACard:(GPTPexeso9Card*) card WithCompletionBlock: (void (^)(BOOL))block;
- (void) turnACardFromBackToFaceWithAnimation: (GPTPexeso9Card*)card;
- (void) turnACardFromFaceToBackWithAnimation: (GPTPexeso9Card*)card;


@end
