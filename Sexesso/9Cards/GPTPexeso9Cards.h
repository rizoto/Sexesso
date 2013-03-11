//
//  GPTPexesoCard.h
//  FlipFlop
//
//  Created by Lubor Kolacny on 1/02/13.
//  Copyright (c) 2013 Lubor Kolacny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPTPexeso9Card : UIImageView

@property BOOL bFaceSide;
@property NSString *faceCard;
@property NSString *backCard;
@property CGRect size;
@property UIGestureRecognizer *cardGestureRecognizer;

@end
