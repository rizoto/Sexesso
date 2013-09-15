//
//  GPTSettings.h
//  Sexesso
//
//  Created by Lubor Kolacny on 19/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPTSettings : NSObject

@property   char         difficulty; // easy,hard,crazy
@property   int         notifications;
@property   NSString    *collection; // TODO 1.1 Vanessa or Aurora
@property   NSMutableDictionary     *score;
@property   NSString    *yourEmail;
@property   int         gamesColl1Played; //home many times you finished a game
@property   int         gamesColl2Played;
@property   NSString    *userID;

- (id)init;
- (void) saveSettings;
- (void) postSavedData;


@end
