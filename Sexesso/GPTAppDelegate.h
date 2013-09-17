//
//  GPTAppDelegate.h
//  Sexesso
//
//  Created by Lubor Kolacny on 14/07/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSTimer *singeltonGameTimer; // only one game timer for the whole game

- (void)changeRootViewController:(NSString *)controllerName;



@end
