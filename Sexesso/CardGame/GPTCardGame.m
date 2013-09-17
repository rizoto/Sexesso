//
//  GPTCardGame.m
//  Sexesso
//
//  Created by Lubor Kolacny on 10/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTCardGame.h"
#import "GPTCard.h" 
#import "game_def.h"


// TODO 1.1 - numbers of cards hardcoded
#import "game_def.h"

@implementation GPTCardGame


// load card collection
-(void) loadAndInitCardsWithCollection: (NSString*) collection
{
    self.cardCollection = [self loadCollectionByName:collection];
}

// load collection by Name
-(NSMutableArray*) loadCollectionByName: (NSString*) collectionName
{
    NSMutableArray* collection = [[NSMutableArray alloc] initWithCapacity:CARDS_IN_GAME];
    UIImage* bgImage;
    // TODO 1.1 - collections hardcoded
    NSArray* collectionInGame;
    if ([collectionName isEqualToString:COLLECTION1]) {
        //Vanessa
        collectionInGame = [[NSArray alloc] initWithObjects: @"joker", @"cards-03_vanessa",@"cards-04_vanessa",@"cards-05_vanessa",@"cards-06_vanessa", nil];
        //load collection card background image
        bgImage = [UIImage imageNamed:@"cards_back-05"];
    } else if ([collectionName isEqualToString:COLLECTION2]) {
        //Aurora
        NSMutableArray *aurora = [[NSMutableArray alloc] initWithObjects: @"cards-02",@"cards-07",@"cards-08",@"cards-09",@"cards-10",
                            @"cards-11",@"cards-12",@"cards-13",@"cards-14",@"cards-15",@"cards-16",@"cards-17",
                            @"cards-18",@"cards-19",@"cards-20",@"cards-21",@"cards-22",@"cards-23",nil];
        srandom( time( NULL ) );
        for (int j = 0;  j < 1000000; j++) {
            int swapA = (random() % aurora.count);
            int swapB = (random() % aurora.count);
            if (swapA != swapB) {
                id temp = aurora[swapA];
                aurora[swapA] = aurora[swapB];
                aurora[swapB] = temp;
            }
        }
        GPTLog(@"Aurora: %@",aurora);
        //load collection card background image
        int x = (random() % 5) + 1; // 1-6
        bgImage = [UIImage imageNamed:[NSString stringWithFormat:@"cards_back-%02d",x]]; //@"cards_back-04"
        // add joker at index 0
        [aurora replaceObjectAtIndex:0 withObject:@"joker"];
        collectionInGame = aurora;
    }
    
    int iCardsInCollection = (CARDS_IN_GAME / 2) + 1; // plus Joker
    
    for (int i = 0;  i < iCardsInCollection; i++) {
        
        // create a card, turn face down;
        GPTCard* card;
        UIImage* uiImage;
        // joker = 0
        uiImage = [UIImage imageNamed:collectionInGame[i]];
        card = [[GPTCard alloc] initWithFaceImage:uiImage BgImage:bgImage Value: [NSNumber numberWithInt:i]];
        [collection addObject:card];
        if(i != 0) { // joker, add only one card otherwise another copy of same card
            GPTCard* card2;
            UIImage* uiImage2;
            uiImage2 = [UIImage imageNamed:collectionInGame[i]];
            card2 = [[GPTCard alloc] initWithFaceImage:uiImage2 BgImage:bgImage Value: [NSNumber numberWithInt:i]];
            [collection addObject:card2];
        }
    }
    
    
    // return collection
    return collection;

}



@end
