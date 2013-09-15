//
//  GPTCard.m
//  Sexesso
//
//  Created by Lubor Kolacny on 10/08/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import "GPTCard.h"
#import "game_def.h"

@interface GPTCard()


@property   UIImage*    bg; // card background
@property   UIImage*    face; // card face


@end


@implementation GPTCard

- (id) initWithFaceImage:(UIImage *)image BgImage: (UIImage *)bgImage Value: (NSNumber*) value
{
    self = [super initWithImage:image];
    if (self) {
        self.cardValue = value;
        self.faceDown = NO;
        self.bg = bgImage;
        self.face = image;
        self.OriginFrame = self.frame;
        self.userInteractionEnabled = YES;
        self.SmallFrame = CGRectMake(0, 0, self.frame.size.width / SMALL_CARD, self.frame.size.height / SMALL_CARD) ;
    }
    
    return self;
    
}

- (void) flip
{
    if (self.faceDown) {
        self.image = self.face;
        self.faceDown = NO;
    }
    else {
        self.image = self.bg;
        self.faceDown = YES;
    }
}


@end
