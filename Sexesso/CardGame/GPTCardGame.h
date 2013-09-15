//
//  GPTCardGame.h
//  Sexesso
//
//  Created by Lubor Kolacny on 10/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPTCardGame : NSObject

@property NSMutableArray* cardCollection;

-(void) loadAndInitCardsWithCollection: (NSString*) collection;

@end
