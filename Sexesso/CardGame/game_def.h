//
//  game_def.h
//  Sexesso
//
//  Created by Lubor Kolacny on 13/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#ifndef Sexesso_game_def_h
#define Sexesso_game_def_h

#define CARDS_IN_GAME   9
#define COLLECTION1     @"Vanessa"
#define COLLECTION2     @"Aurora"
#define TI_MOVE_DELAY         0.2
#define TI_REMOVE_DELAY       1.0
#define TI_MOVE_DURATION      0.5
#define TI_REMOVE_DURATION    1.0
#define TI_FLIP_CARD          0.5
#define TI_FLIP_UNMATCH       2.0
#define SHUFFLE         10
#define SMALL_CARD      4
#define EASY_GAME       'E'
#define HARD_GAME       'H'
#define CRAZY_GAME      'C'
#define NOTIFY_OFF      0
#define NOTIFY_ON       1
#define EASY_GAME_LIMIT 3*60
#define HARD_GAME_LIMIT (4*60)
#define CRAZY_GAME_LIMIT (5*60)
#define MAX_GAME_LIMIT       (9*60)+59   // only for score
#define keyCollectionSelected   @"keyCollectionSelected"
#define keyDifficultySelected   @"keyDifficultySelected"
#define keyAlerts               @"keyAlerts"
#define keyCollection1Score     @"keyCollection1Score"
#define keyCollection2Score     @"keyCollection2Score"
#define keyScore                @"keyScore"
#define keyData2Save            @"keyData2Save"
#define keyEasyGame             @"keyEasyGame"
#define keyHardGame             @"keyHardGame"
#define keyCrazyGame            @"keyCrazyGame"
#define keyEasyGameCollection2             @"keyEasyGameAurora"
#define keyHardGameCollection2             @"keyHardGameAurora"
#define keyCrazyGameCollection2            @"keyCrazyGameAurora"
#define keyEasyGameCollection1             @"keyEasyGameVanessa"
#define keyHardGameCollection1             @"keyHardGameVanessa"
#define keyCrazyGameCollection1            @"keyCrazyGameVanessa"
#define keyGamePlayedCollection1           @"keyGameVanessaPlayed"
#define keyGamePlayedCollection2           @"keyGameAuroraPlayed"
#define keyYourEmail            @"keyYourEmail"
#define keyUserID               @"keyUserID"
#define keyDeviceToken          @"keyDeviceToken"
#define keyDeviceType           @"keyDeviceType"
#define keyInstalled_iOS        @"keyInstalled_iOS"

#define app     ((GPTAppDelegate*)[UIApplication sharedApplication].delegate)
#define GPTLog   NSLog
#define GPTLog1  NSLog
#define alertViewNewGame    100
#define alertViewLeaveGame  101
#define alertViewGameOver   102
#define alertViewJokerFinishGame   103
#define gameCancelled 0
#define gameRunning   1
#define gamePaused    2

#endif
