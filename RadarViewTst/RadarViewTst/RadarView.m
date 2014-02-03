//
//  RadarView.m
//  RadarViewTst
//
//  Created by BjornC on 1/27/14.
//  Copyright (c) 2014 BjornC. All rights reserved.
//

#import "RadarView.h"

@interface RadarView () {
    CAShapeLayer *radarGridLayer;
    CGColorRef radarGridColor;
    float radarGridLineWidth;
    UIBezierPath *radarGridPath;
}

@end

@implementation RadarView

-(void) sharedInit {
    radarGridLayer = [CAShapeLayer layer];
    radarGridColor = [UIColor whiteColor].CGColor;
    radarGridLineWidth = 1.0;
}

-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [radarGridLayer setFrame:frame];
        [self sharedInit];
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [radarGridLayer setFrame:self.frame];
        [self sharedInit];
    }
    return self;
}

#define RADAR_GRID_LINE_INSET 5.0
#define RADAR_GRID_LINE_ROT_ANGLE M_PI/4

-(void) drawGridLines {
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    CGPoint drawPt = { CGRectGetMidX(self.bounds), RADAR_GRID_LINE_INSET };
    [linePath moveToPoint:drawPt];
    drawPt.y = self.bounds.size.height-RADAR_GRID_LINE_INSET ;
    [linePath addLineToPoint:drawPt];
    
    drawPt.x = RADAR_GRID_LINE_INSET;
    drawPt.y = CGRectGetMidY(self.bounds);
    [linePath moveToPoint:drawPt];
    
    drawPt.x = self.bounds.size.width-RADAR_GRID_LINE_INSET;
    [linePath addLineToPoint:drawPt];
 
    [linePath stroke];
    
    UIBezierPath *linePath2 = [linePath copy];
    CGAffineTransform toOrigin = CGAffineTransformMakeTranslation(-CGRectGetMidX(self.bounds), -(CGRectGetMidY(self.bounds)));
    CGAffineTransform fromOrigin = CGAffineTransformMakeTranslation(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGAffineTransform lineSpin = CGAffineTransformMakeRotation(RADAR_GRID_LINE_ROT_ANGLE);

    [linePath2 applyTransform:toOrigin];
    [linePath2 applyTransform:lineSpin];
    [linePath2 applyTransform:fromOrigin];
    
    [linePath2 stroke];
    [radarGridPath appendPath:linePath];
    [radarGridPath appendPath:linePath2];
    
}

#define RADAR_GRID_INIT_CIRC_INSET 20
#define RADAR_GRID_CIRCLE_INSET 20

-(void) drawGridCircles {
    CGRect gridCircleBounds = CGRectInset(self.bounds, RADAR_GRID_INIT_CIRC_INSET, RADAR_GRID_INIT_CIRC_INSET);
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:gridCircleBounds];
    [circlePath stroke];
    [radarGridPath appendPath:circlePath];
     gridCircleBounds = CGRectInset(gridCircleBounds, RADAR_GRID_CIRCLE_INSET, RADAR_GRID_CIRCLE_INSET);
    circlePath = [UIBezierPath bezierPathWithOvalInRect:gridCircleBounds];
    [circlePath stroke];
    [radarGridPath appendPath:circlePath];
    
    gridCircleBounds = CGRectInset(gridCircleBounds, RADAR_GRID_CIRCLE_INSET, RADAR_GRID_CIRCLE_INSET);
    circlePath = [UIBezierPath bezierPathWithOvalInRect:gridCircleBounds];
    [circlePath stroke];
    [radarGridPath appendPath:circlePath];

    gridCircleBounds = CGRectInset(gridCircleBounds, RADAR_GRID_CIRCLE_INSET, RADAR_GRID_CIRCLE_INSET);
    circlePath = [UIBezierPath bezierPathWithOvalInRect:gridCircleBounds];
    [circlePath stroke];
    [radarGridPath appendPath:circlePath];

    gridCircleBounds = CGRectInset(gridCircleBounds, RADAR_GRID_CIRCLE_INSET, RADAR_GRID_CIRCLE_INSET);
    circlePath = [UIBezierPath bezierPathWithOvalInRect:gridCircleBounds];
    [circlePath stroke];
    [radarGridPath appendPath:circlePath];

    gridCircleBounds = CGRectInset(gridCircleBounds, RADAR_GRID_CIRCLE_INSET, RADAR_GRID_CIRCLE_INSET);
    circlePath = [UIBezierPath bezierPathWithOvalInRect:gridCircleBounds];
    [circlePath stroke];
    [radarGridPath appendPath:circlePath];

    gridCircleBounds = CGRectInset(gridCircleBounds, RADAR_GRID_CIRCLE_INSET, RADAR_GRID_CIRCLE_INSET);
    circlePath = [UIBezierPath bezierPathWithOvalInRect:gridCircleBounds];
    [circlePath stroke];
    [radarGridPath appendPath:circlePath];
}

-(void) drawRadarGrid {
    // setup
    radarGridPath = [UIBezierPath bezierPath];
    [radarGridLayer setStrokeColor:radarGridColor];
    [radarGridLayer setLineWidth:radarGridLineWidth];
    // draw the grid
    [self drawGridCircles];
    [self drawGridLines];
    // apply the layer
    radarGridLayer.path = radarGridPath.CGPath;
    [self.layer addSublayer:radarGridLayer];
    
}

#define DONUT_WIDTH 8
#define OUTER_DONUT_SIZE 24


-(void) drawDonutAtPt:(CGPoint)pt withColor:(UIColor*)donutColor {
    CAShapeLayer *donutLayer = [CAShapeLayer layer];
    [donutLayer setStrokeColor:donutColor.CGColor];
    [donutLayer setFillColor:[UIColor clearColor].CGColor];
    donutLayer.bounds = CGRectMake(0, 0, OUTER_DONUT_SIZE, OUTER_DONUT_SIZE);
    donutLayer.backgroundColor = [UIColor clearColor].CGColor;
    donutLayer.position = pt;
    donutLayer.opacity = 1.0;
    donutLayer.lineWidth = DONUT_WIDTH;
    donutLayer.borderWidth = 0.0;
    CGRect outerRect = donutLayer.bounds;
    
    UIBezierPath *donutPath = [UIBezierPath bezierPathWithOvalInRect:outerRect];
    [donutPath stroke];
    donutLayer.path = donutPath.CGPath;
    [self.layer addSublayer:donutLayer];
}

#define DOT_SIZE 10

-(void) drawDotAtPt:(CGPoint)pt withColor:(UIColor*)dotColor {
    CAShapeLayer *dotLayer = [CAShapeLayer layer];
    [dotLayer setStrokeColor:[UIColor whiteColor].CGColor];
    [dotLayer setFillColor:dotColor.CGColor];
    //dotLayer.backgroundColor = [UIColor redColor].CGColor;
    dotLayer.bounds = CGRectMake(0,0,DOT_SIZE, DOT_SIZE);
    dotLayer.position = pt;
    dotLayer.opacity = 1.0;
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithOvalInRect:dotLayer.bounds];
    dotPath.lineWidth = 2.0;
    //dotPath.usesEvenOddFillRule = YES;
    [dotPath fill];
    [dotPath stroke];
    dotLayer.path = dotPath.CGPath;
    [self.layer addSublayer:dotLayer];
    
}


-(void) drawRect:(CGRect)rect
{
    [self drawRadarGrid];
    [self drawDotAtPt:CGPointMake(55, 70) withColor:[UIColor blueColor]];
    
    [self drawDonutAtPt:CGPointMake(80, 90) withColor:[UIColor greenColor]];
    
    [self drawDotAtPt:CGPointMake(240, 130) withColor:[UIColor redColor]];
    [self drawDotAtPt:CGPointMake(185, 170) withColor:[UIColor blueColor]];
    [self drawDotAtPt:CGPointMake(80, 90) withColor:[UIColor greenColor]];

}


@end
