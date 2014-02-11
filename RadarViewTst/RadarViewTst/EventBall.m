//
//  EventBall.m
//  RadarViewTst
//
//  Created by BjornC on 2/4/14.
//  Copyright (c) 2014 BjornC. All rights reserved.
//

#import "EventBall.h"

@interface EventBall ()

@property (nonatomic,strong) CAShapeLayer *ourLayer;
@property BOOL selected;
@property CGPoint ballPosition;

@property (nonatomic,strong) CAShapeLayer *donutLayer;

@end

#define DOT_SIZE 10

@implementation EventBall

-(instancetype) initWithColor:(UIColor *)color
                  andPosition:(CGPoint)pos
                     andIdent:(NSString *)ident{
    self = [super init];
    if (self) {
        self.ourLayer = [CAShapeLayer layer];
        self.ourLayer.bounds = CGRectMake(0, 0, DOT_SIZE, DOT_SIZE);
        self.ourLayer.opacity = 1.0;
        self.ourLayer.position = pos;
        UIBezierPath *ballPath = [UIBezierPath bezierPathWithOvalInRect:self.ourLayer.bounds];
        ballPath.lineWidth = 2.0;
        //[ballPath fill];
        //[ballPath stroke];
        self.ourLayer.path = ballPath.CGPath;
        self.ballColor = color;
        self.ballPosition = pos;
        self.selected = NO;
        self.identifier = ident;
        //[self createDonutLayer];
        
    }
    return self;
}

#define DONUT_WIDTH 8
#define OUTER_DONUT_SIZE 24

-(void) createDonutLayer {
    self.donutLayer = [CAShapeLayer layer];
    self.donutLayer.bounds = CGRectMake(0, 0, OUTER_DONUT_SIZE, OUTER_DONUT_SIZE);
    [self.donutLayer setStrokeColor:self.ballColor.CGColor];
    [self.donutLayer setFillColor:[UIColor clearColor].CGColor];
    self.donutLayer.position = self.ourLayer.position;
    self.donutLayer.opacity = 1.0;
    self.donutLayer.lineWidth = DONUT_WIDTH;
    CGRect outerRect = self.donutLayer.bounds;
    UIBezierPath *donutPath = [UIBezierPath bezierPathWithOvalInRect:outerRect];
    //[donutPath stroke];
    self.donutLayer.path = donutPath.CGPath;
    [self.ourLayer addSublayer:self.donutLayer];
}

-(CALayer*) eventBallLayer {
    [self.ourLayer setStrokeColor:[UIColor whiteColor].CGColor];
    [self.ourLayer setFillColor:self.ballColor.CGColor];
    return self.ourLayer;
    
}

#pragma mark - change event attributes
-(void) changeEventPosition:(CGPoint)pt {
    self.ourLayer.position = pt;
}

-(void) changeEventColor:(UIColor *)color {
    [self.ourLayer setFillColor:color.CGColor];
}

-(void) makeEventSelected { }
-(void) makeEventUnselected {}





@end
