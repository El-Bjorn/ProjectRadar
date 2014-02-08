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
        
    }
    return self;
}

-(CALayer*) eventBallLayer {
    [self.ourLayer setStrokeColor:[UIColor whiteColor].CGColor];
    [self.ourLayer setFillColor:self.ballColor.CGColor];
    return self.ourLayer;
    
}

@end
