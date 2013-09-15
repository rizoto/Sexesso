//
//  UIViewController+AutoNibName.m
//  Sexesso
//
//  Created by Lubor Kolacny on 31/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "UIViewController+AutoNibName.h"
#import "devices.h"

@implementation UIViewController (AutoNibName)

+ (NSString*) autoNibName: (NSString*) nibNameOrNil {
    if(nibNameOrNil) {
        if (IS_WIDESCREEN) {
            return nibNameOrNil;
        } else {
            return [nibNameOrNil stringByAppendingString:CLASSIC_SCREEN];
        }
    }
    return nil;
}

@end
