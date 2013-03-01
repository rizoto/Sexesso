//
//  GPTAppDelegate.h
//  Sexesso
//
//  Created by Lubor Kolacny on 9/02/13.
//  Copyright (c) 2013 Green Plus Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPTViewController;

@interface GPTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) GPTViewController *viewController;
@property (strong, nonatomic) UINavigationController *navigationController;

@end
