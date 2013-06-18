//
//  device_def.h
//  Sexesso
//
//  Created by Lubor Kolacny on 16/06/13.
//  Copyright (c) 2013 Green Plus Technology. All rights reserved.
//

#ifndef Sexesso_device_def_h
#define Sexesso_device_def_h

#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_ ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )


#define HEIGHT_IPHONE_5 568
#define IS_IPHONE   ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5 )

#endif
