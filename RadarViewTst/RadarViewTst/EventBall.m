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
#define DONUT_WIDTH 8
#define OUTER_DONUT_SIZE 24

#define DOT_INSET (OUTER_DONUT_SIZE-DOT_SIZE)/2.0


@implementation EventBall

-(instancetype) initWithColor:(UIColor *)color
                  andPosition:(CGPoint)pos
                     andIdent:(NSString *)ident{
    self = [super init];
    if (self) {
        self.ourLayer = [CAShapeLayer layer];
       // self.ourLayer.bounds = CGRectMake(0, 0, DOT_SIZE, DOT_SIZE);
        self.ourLayer.bounds = CGRectMake(0, 0, OUTER_DONUT_SIZE, OUTER_DONUT_SIZE);
        self.ourLayer.opacity = 1.0;
        self.ourLayer.position = pos;
        //self.donutLayer = [[CAShapeLayer alloc] initWithLayer:self.ourLayer];
        //self.ourLayer.backgroundColor = [UIColor brownColor].CGColor;
        //CGRect ballRect = CGRectMake(0, 0, DOT_SIZE, DOT_SIZE);
        CGRect ballRect = CGRectInset(self.ourLayer.bounds, DOT_INSET, DOT_INSET);
        //UIBezierPath *ballPath = [UIBezierPath bezierPathWithOvalInRect:self.ourLayer.bounds];
        UIBezierPath *ballPath = [UIBezierPath bezierPathWithOvalInRect:ballRect];

        ballPath.lineWidth = 2.0;
        //[ballPath fill];
        //[ballPath stroke];
        self.ourLayer.path = ballPath.CGPath;
        self.ballColor = color;
        self.ballPosition = pos;
        self.selected = NO;
        self.identifier = ident;
        [self createDonutLayer];
        //self.ourLayer.position = pos;
        
    }
    return self;
}


-(void) createDonutLayer {
    self.donutLayer = [CAShapeLayer layer];
    //self.donutLayer.bounds = CGRectMake(0, 0, OUTER_DONUT_SIZE, OUTER_DONUT_SIZE);
    self.donutLayer.frame = self.ourLayer.bounds;
    
    [self.donutLayer setStrokeColor:self.ballColor.CGColor];
    [self.donutLayer setFillColor:[UIColor clearColor].CGColor];
    //self.donutLayer.position = self.ourLayer.position;
    //self.donutLayer.position = CGPointMake(0, 0);
    //self.donutLayer.position = [self.donutLayer convertPoint:self.ourLayer.position fromLayer:self.ourLayer];
    self.donutLayer.opacity = 1.0;
    //self.donutLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
    self.donutLayer.lineWidth = DONUT_WIDTH;
    CGRect outerRect = self.donutLayer.bounds;
    UIBezierPath *donutPath = [UIBezierPath bezierPathWithOvalInRect:outerRect];
    //donutPath.lineWidth = DONUT_WIDTH;
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
