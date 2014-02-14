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

// how fast we move within the radar view
@property float eventSpeed;


-(CALayer*) eventBallLayer;

-(instancetype) initWithColor:(UIColor*)color
                  andPosition:(CGPoint)pos
                     andSpeed:(float)speed
                     andIdent:(NSString*)identity;


-(void) removeEvent;

// step (at eventSpeed) toward center
-(void) stepTowardCenter;

-(void) changeEventPosition:(CGPoint)pt;
-(void) changeEventColor:(UIColor*)color;

// is the tap ours?
-(BOOL) pointInEvent:(CGPoint)pt;

-(void) toggleSelection;

-(void) makeEventSelected;
-(void) makeEventUnselected;

@end
