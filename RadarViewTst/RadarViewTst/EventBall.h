//
//  EventBall.h
//  RadarViewTst
//
//  Created by BjornC on 2/4/14.
//  Copyright (c) 2014 BjornC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventBall : NSObject

@property (nonatomic,strong) UIColor *ballColor;
@property BOOL selected;
@property (nonatomic,weak) CALayer *radarLayer;
@property CGPoint ballPosition;
@property (nonatomic,strong) NSString *identifier;

-(instancetype) initWithColor:(UIColor*)color
                  andPosition:(CGPoint)pos
                     andIdent:(NSString*)identity;

-(CALayer*) eventBallLayer;

@end
