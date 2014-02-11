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
@property (nonatomic,strong) NSString *identifier;
-(CALayer*) eventBallLayer;

-(instancetype) initWithColor:(UIColor*)color
                  andPosition:(CGPoint)pos
                     andIdent:(NSString*)identity;

// change attributes, modify our layer
-(void) changeEventPosition:(CGPoint)pt;
-(void) changeEventColor:(UIColor*)color;

-(void) makeEventSelected;
-(void) makeEventUnselected;

@end
