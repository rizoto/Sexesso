//
//  GPTCard.h
//  Sexesso
//
//  Created by Lubor Kolacny on 10/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPTCard : UIImageView

@property   BOOL        faceDown;
@property   NSNumber*  cardValue;
@property   CGRect     OriginFrame;
@property   CGRect     SmallFrame;

- (id) initWithFaceImage:(UIImage *)image BgImage: (UIImage *)bgImage Value: (NSNumber*) value;
- (void) flip;

@end
