//
//  GPTSettings.m
//  Sexesso
//
//  Created by Lubor Kolacny on 19/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTSettings.h"
#import "game_def.h"

@implementation GPTSettings

- (id)init
{
    self = [super init];
    if (self) {
        [self loadSettings];
        // default settings
        switch (self.difficulty) {
            case EASY_GAME:
            case HARD_GAME:
            case CRAZY_GAME:
                break;
            default:
                self.difficulty = EASY_GAME;
                break;
        }
        if (!self.collection) {
            self.collection = COLLECTION2;
        }
        if (!self.yourEmail) {
            self.yourEmail = @"";
        }
        if (!self.score) {
        NSMutableArray *score_max = [NSMutableArray arrayWithObjects:[NSNumber numberWithLong:MAX_GAME_LIMIT], [NSNumber numberWithLong:MAX_GAME_LIMIT],[NSNumber numberWithLong:MAX_GAME_LIMIT],[NSNumber numberWithLong:MAX_GAME_LIMIT],[NSNumber numberWithLong:MAX_GAME_LIMIT],[NSNumber numberWithLong:MAX_GAME_LIMIT],[NSNumber numberWithLong:MAX_GAME_LIMIT],[NSNumber numberWithLong:MAX_GAME_LIMIT],[NSNumber numberWithLong:MAX_GAME_LIMIT],[NSNumber numberWithLong:MAX_GAME_LIMIT], nil];
        self.score = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSMutableArray alloc] initWithArray:score_max copyItems:YES],keyEasyGame,[[NSMutableArray alloc] initWithArray:score_max copyItems:YES],keyHardGame,[[NSMutableArray alloc] initWithArray:score_max copyItems:YES],keyCrazyGame, nil],COLLECTION1,[NSMutableDictionary dictionaryWithObjectsAndKeys:[[NSMutableArray alloc] initWithArray:score_max copyItems:YES],keyEasyGame,[[NSMutableArray alloc] initWithArray:score_max copyItems:YES],keyHardGame,[[NSMutableArray alloc] initWithArray:score_max copyItems:YES],keyCrazyGame, nil],COLLECTION2,nil];
            GPTLog(@"%@",self.score);
            self.gamesColl1Played = 0;
            self.gamesColl2Played = 0;
            [self saveSettings];
            [self loadSettings];
        }
        self.userID = [self userId];
        GPTLog(@"UserID: %@:",self.userID);
    }
    return self;
}

- (NSString*)userId
{
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:keyUserID];
    if (userId == nil || userId.length == 0) {
        // GUID
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        NSString *cfuuidString = (__bridge_transfer NSString *)string ;
        //        
        [[NSUserDefaults standardUserDefaults] setObject:cfuuidString forKey:keyUserID];
    }
    return userId;
}

- (void) saveSettings
{
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    [u setInteger:(int)self.difficulty forKey:keyDifficultySelected];
    [u setInteger:(int)self.gamesColl1Played forKey:keyGamePlayedCollection1];
    [u setInteger:(int)self.gamesColl2Played forKey:keyGamePlayedCollection2];
    [u setObject:self.collection forKey:keyCollectionSelected];
    [u setInteger:self.notifications forKey:keyAlerts];
    [u setObject:self.yourEmail forKey:keyYourEmail];
    //[u setObject:self.score forKey:keyScore];
    [u setObject:[[self.score objectForKey:COLLECTION1] objectForKey:keyCrazyGame] forKey:keyCrazyGameCollection1];
    [u setObject:[[self.score objectForKey:COLLECTION1] objectForKey:keyHardGame] forKey:keyHardGameCollection1];
    [u setObject:[[self.score objectForKey:COLLECTION1] objectForKey:keyEasyGame] forKey:keyEasyGameCollection1];
    [u setObject:[[self.score objectForKey:COLLECTION2] objectForKey:keyCrazyGame] forKey:keyCrazyGameCollection2];
    [u setObject:[[self.score objectForKey:COLLECTION2] objectForKey:keyHardGame] forKey:keyHardGameCollection2];
    [u setObject:[[self.score objectForKey:COLLECTION2] objectForKey:keyEasyGame] forKey:keyEasyGameCollection2];
    [u synchronize];
    [self postSavedData];
}

- (void) loadSettings
{
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];
    if ([u objectForKey:keyEasyGameCollection1]) {
        self.difficulty = (char)[u integerForKey:keyDifficultySelected];
        self.gamesColl1Played = [u integerForKey:keyGamePlayedCollection1];
        self.gamesColl2Played = [u integerForKey:keyGamePlayedCollection2];
        self.collection = (NSString*)[u stringForKey:keyCollectionSelected];
        self.notifications = [u integerForKey:keyAlerts];
        self.yourEmail = [u objectForKey:keyYourEmail];
        //self.score = [u objectForKey:keyScore];
        self.score = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray arrayWithArray:[u objectForKey:keyEasyGameCollection1]],keyEasyGame,[NSMutableArray arrayWithArray:[u objectForKey:keyHardGameCollection1]],keyHardGame,[NSMutableArray arrayWithArray:[u objectForKey:keyCrazyGameCollection1]],keyCrazyGame, nil],COLLECTION1,[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableArray arrayWithArray:[u objectForKey:keyEasyGameCollection2]],keyEasyGame,[NSMutableArray arrayWithArray:[u objectForKey:keyHardGameCollection2]],keyHardGame,[NSMutableArray arrayWithArray:[u objectForKey:keyCrazyGameCollection2]],keyCrazyGame, nil],COLLECTION2,nil];
            GPTLog(@"%@",self.score);
    }
}

- (void) postSavedData
{
    GPTLog(@"------- Saving Data on Server -------------");
    // Get a dictionary of the user defaults
    NSUserDefaults *u = [NSUserDefaults standardUserDefaults];

    NSArray *uiDevice = @[[[UIDevice currentDevice] name],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion],[[UIDevice currentDevice] model],[[UIDevice currentDevice] localizedModel],[[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone?@"UIUserInterfaceIdiomPhone":@"UIUserInterfaceIdiomPad"];
    NSDictionary *dict = [u dictionaryRepresentation];
    NSString *dataString = [NSString stringWithFormat:@"data=[[%@,%@]]&userID=%@",[uiDevice description],[dict description],self.userID];
    GPTLog(@"UIDevice: %@", dataString);
    
    //NSString *post = @"data=test_from_game";
    NSData *postData = [dataString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://sexesso.com:8080/WebDeviceReg/save"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^{
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    }];

}

@end
