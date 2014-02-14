//
//  RadarView.m
//  RadarViewTst
//
//  Created by BjornC on 1/27/14.
//  Copyright (c) 2014 BjornC. All rights reserved.
//

#import "RadarView.h"
#import "EventBall.h"

@interface RadarView () {
    CAShapeLayer *radarGridLayer;
    CGColorRef radarGridColor;
    float radarGridLineWidth;
    UIBezierPath *radarGridPath;
}
// here's where we store the event balls
@property (nonatomic,strong) NSMutableArray *radarEvents;

@end

@implementation RadarView

-(void) sharedInit {
    radarGridLayer = [CAShapeLayer layer];
    radarGridColor = [UIColor whiteColor].CGColor;
    radarGridLineWidth = 1.0;
    self.radarEvents= [[NSMutableArray alloc] init];
    
    // set up tap recog
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    [self addGestureRecognizer:tap];
    [self generateEvents];
    
    //[self drawDotAtPt:CGPointMake(240, 130) withColor:[UIColor redColor]];
    //[self createEventWithColor:[UIColor purpleColor] andPosition:CGPointMake(240,130) andIdent:@"bigJob"];

    //[self drawDotAtPt:CGPointMake(185, 170) withColor:[UIColor blueColor]];
  
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

-(void) resetEvents {
    for (EventBall *b in self.radarEvents) {
        [b removeEvent];
     }
    [self.radarEvents removeAllObjects];
    //[self generateEvents];
    //[self sharedInit];
    [self generateEvents];
    [self setNeedsDisplay];
}

-(void) generateEvents {
    [self createEventWithColor:[UIColor blueColor]
                   andPosition:CGPointMake(185,170)
                      andSpeed:3.0
                      andIdent:@"littleJob"];
    
    //[self eventWithIdent:@"bigJob"];
    [self createEventWithColor:[UIColor redColor] andPosition:CGPointMake(225,130) andSpeed:2 andIdent:@"bigJob1"];
    [self createEventWithColor:[UIColor redColor] andPosition:CGPointMake(255,125) andSpeed:2 andIdent:@"bigJob2"];
    [self createEventWithColor:[UIColor redColor] andPosition:CGPointMake(285,120) andSpeed:2 andIdent:@"bigJob3"];
    //[self createEventWithColor:[UIColor redColor] andPosition:CGPointMake(255,145) andIdent:@"bigJob4"];
    
    
    [self createEventWithColor:[UIColor greenColor] andPosition:CGPointMake(85,70) andSpeed:10 andIdent:@"jobX"];
    
    [self createEventWithColor:[UIColor yellowColor] andPosition:CGPointMake(150,190) andSpeed:4 andIdent:@"JobY1"];
    [self createEventWithColor:[UIColor yellowColor] andPosition:CGPointMake(150,220) andSpeed:4 andIdent:@"littleJY2"];
    
    [self createEventWithColor:[UIColor purpleColor] andPosition:CGPointMake(250, 250) andSpeed:6 andIdent:@"mega-job"];

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
 
    
    UIBezierPath *linePath2 = [linePath copy];
    CGAffineTransform toOrigin = CGAffineTransformMakeTranslation(-CGRectGetMidX(self.bounds), -(CGRectGetMidY(self.bounds)));
    CGAffineTransform fromOrigin = CGAffineTransformMakeTranslation(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGAffineTransform lineSpin = CGAffineTransformMakeRotation(RADAR_GRID_LINE_ROT_ANGLE);

    [linePath2 applyTransform:toOrigin];
    [linePath2 applyTransform:lineSpin];
    [linePath2 applyTransform:fromOrigin];
    
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

/*#define DONUT_WIDTH 8
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
    
} */

-(void) createEventWithColor:(UIColor*)color
                 andPosition:(CGPoint)pt
                    andSpeed:(float)speed
                    andIdent:(NSString*)ident {
    EventBall *b = [[EventBall alloc] initWithColor:color andPosition:pt andSpeed:speed
                                           andIdent:ident];
    [self.radarEvents addObject:b];
}

-(void) displayEvents {
    for (EventBall *b in self.radarEvents) {
        [self.layer addSublayer:[b eventBallLayer]];
    }
}

-(EventBall*) eventWithIdent:(NSString*)ident {
    int eventIndex = [self.radarEvents indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            EventBall* b = obj;
            return [b.identifier isEqualToString:ident];
    }];
    NSLog(@"found event with ident %@: %@",ident,self.radarEvents[eventIndex]);
    return self.radarEvents[eventIndex];    
}

/*-(void) changeStuff {
    NSLog(@"changing stuff");
    EventBall *b = [self eventWithIdent:@"bigJob"];
    [b changeEventPosition:CGPointMake(200, 200)];
    [b changeEventColor:[UIColor purpleColor]];
} */


-(void) drawRect:(CGRect)rect
{
    [self drawRadarGrid];
    [self displayEvents];
    
  /*  double delayInSeconds = 3.0;
    EventBall *b1 = [self eventWithIdent:@"bigJob"];
    EventBall *b2 = [self eventWithIdent:@"littleJob"]; */
    //[b1 makeEventSelected];
   /* dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"changing stuff");
        [b2 makeEventSelected];
        [b1 makeEventUnselected];
        [b1 changeEventPosition:CGPointMake(200, 200)];
        [b1 changeEventColor:[UIColor purpleColor]];

    }); */
    
    
    
    //[self drawDotAtPt:CGPointMake(80, 90) withColor:[UIColor greenColor]];
    //CALayer *ballLayer;
    //EventBall *a = [[EventBall alloc] initWithColor:[UIColor yellowColor] andPosition:CGPointMake(80,140)];
    //ballLayer = [a eventBallLayer];
    //[self.layer addSublayer:ballLayer];

}

-(void) stepTimeForEvents {
    for (EventBall *b in self.radarEvents) {
        [b stepTowardCenter];
    }

}

#pragma mark - tap events
-(void) tapEvent:(UITapGestureRecognizer*)tap {
    CGPoint pt = [tap locationInView:self];
    NSLog(@"caught tap (%.2f,%.2f",pt.x,pt.y);
    
    [self setNeedsDisplay];
    
    for (EventBall *b in self.radarEvents) {
        if ([b pointInEvent:pt]) {
            NSLog(@"tap within event: %@",b.identifier);
            [b toggleSelection];
            return;
        }
    }


}


@end
