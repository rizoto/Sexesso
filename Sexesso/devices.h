//
//  devices.h
//  Sexesso
//
//  Created by Lubor Kolacny on 9/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#ifndef Sexesso_devices_h
#define Sexesso_devices_h

#define IS_WIDESCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)568) < DBL_EPSILON)
#define IS_NORMALSCREEN (fabs((double)[[UIScreen mainScreen]bounds].size.height - (double)480) < DBL_EPSILON)
#define IS_IPHONE (([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) || ([[[UIDevice currentDevice] model] isEqualToString: @"iPhone Simulator"]))
#define IS_IPAD (([[[UIDevice currentDevice] model] isEqualToString:@"iPad"]) || ([[[UIDevice currentDevice] model] isEqualToString: @"iPad Simulator"]))
#define IS_IPOD   ([[[UIDevice currentDevice]model] isEqualToString:@"iPod touch"])
#define IS_IPHONE_IPOD_5 ((IS_IPHONE || IS_IPOD) && IS_WIDESCREEN)
#define IS_IPHONE_IPOD_CLASSIC ((IS_IPHONE || IS_IPOD) && IS_NORMALSCREEN)
#define CLASSIC_SCREEN @"~Classic"

#endif
