//
//  ViewController.m
//  ProjectRadar
//
//  Created by BjornC on 4/10/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "RadarViewController.h"
#import "ProjectManager.h"

@interface RadarViewController ()
@property (nonatomic,assign) long current_scale_index;
@property (nonatomic,strong) NSArray *scalingTable;

@end

#pragma mark - utility functions
UIBezierPath *trajMarkerPath(UIColor *color);
CGPoint markerPosition(double traj, CGPoint center, double dist);
void transformForTraj(CALayer *lay, double traj);


@implementation RadarViewController

#define SCALE_VALUE @"scaleValue"
#define SCALE_TEXT  @"scaleText"



- (void)viewDidLoad {
    [super viewDidLoad];
    self.current_scale_index = 2;
    [self setupScalingTable];
    self.radarGrid.currentScale = [self.scalingTable[self.current_scale_index][SCALE_VALUE] doubleValue];
    self.scaleLabel.text = self.scalingTable[self.current_scale_index][SCALE_TEXT];
    
}

#define MARKER_X_SIZE 15.95
#define MARKER_Y_SIZE 19.78

-(void) viewDidAppear:(BOOL)animated {
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *delivs = [pm allDeliverables];
    
    self.radarGrid.layer.sublayers = nil;
    
    for (Deliverable *d in delivs) {
        d.ballLayer = [d generateBallLayer];
        [self.radarGrid.layer addSublayer:d.ballLayer];
        [d repositionInRect:self.radarGrid.bounds withScale:self.radarGrid.currentScale];
    }
    // trajectory markers
    CGRect rect = self.radarGrid.bounds;
    for (Project *p in [pm allProjects]) {
        CAShapeLayer *markerLayer = [CAShapeLayer layer];
        //markerLayer.backgroundColor = [UIColor blueColor].CGColor;
        markerLayer.hidden = NO;
        markerLayer.bounds = CGRectMake(0, 0, MARKER_X_SIZE, MARKER_Y_SIZE);
        markerLayer.opacity = 1.0;
        markerLayer.path = trajMarkerPath(p.projColor).CGPath;
        markerLayer.fillColor = p.projColor.CGColor;
        //markerLayer.path = trajMarkerPath([UIColor redColor]).CGPath;
        
        markerLayer.position = markerPosition([p.trajectRadian doubleValue],
                                              CGPointMake(rect.size.width/2.0, rect.size.height/2.0),
                                              rect.size.width/2.0-5);
        transformForTraj(markerLayer, [p.trajectRadian doubleValue]);
        
        [self.radarGrid.layer addSublayer:markerLayer];
    }


    
}

-(void) setupScalingTable {
    self.scalingTable = @[ @{SCALE_TEXT: @"6 hours", SCALE_VALUE: @(60.0)},
                           @{SCALE_TEXT: @"12 hours", SCALE_VALUE: @(30.0)},
                           @{ SCALE_TEXT: @"1 Day", SCALE_VALUE: @(15.0) },
                           @{ SCALE_TEXT: @"2 Days", SCALE_VALUE: @(7.2) },
                           @{ SCALE_TEXT: @"3 Days", SCALE_VALUE: @(4.5) },
                           @{ SCALE_TEXT: @"7 Days", SCALE_VALUE: @(2.0) },
                           @{ SCALE_TEXT: @"14 Days",SCALE_VALUE: @(0.9) },
                           @{ SCALE_TEXT: @"1 Month",SCALE_VALUE: @(0.45) },
                           @{ SCALE_TEXT: @"2 Months", SCALE_VALUE: @(0.225) }
                           ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender {
    static BOOL pinchLock = NO;
    if (pinchLock == NO) {
        //NSLog(@"pinched! ouch! velocity = %lf",sender.velocity);
        if (sender.scale > 1.0) { // reduce radar screen
            //self.radarGrid.currentScale -= 0.1;
            self.current_scale_index--;
            if (self.current_scale_index < 0) {
                self.current_scale_index = 0;
            }
        } else {
            self.current_scale_index++;
            if (self.current_scale_index >= self.scalingTable.count) {
                self.current_scale_index = self.scalingTable.count-1;
            }
            //self.radarGrid.currentScale += 0.1;
        }
        self.radarGrid.currentScale = [self.scalingTable[self.current_scale_index][SCALE_VALUE] doubleValue];
        self.scaleLabel.text = self.scalingTable[self.current_scale_index][SCALE_TEXT];
        printf("current grid scale: %lf\n",self.radarGrid.currentScale);
        // disable for a moment
        //NSLog(@"disabling pinch");
        //sender.enabled = NO;
        pinchLock = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //NSLog(@"reenabling pinch");
            //sender.enabled = YES;
            pinchLock = NO;
        });
        [self.radarGrid setNeedsDisplay];

    }
    
    

}

- (IBAction)tappedRadar:(UITapGestureRecognizer *)sender {
    self.current_scale_index = (self.current_scale_index+1)%self.scalingTable.count;
    NSLog(@"got tap");
    self.radarGrid.currentScale = [self.scalingTable[self.current_scale_index][SCALE_VALUE] doubleValue];
    self.scaleLabel.text = self.scalingTable[self.current_scale_index][SCALE_TEXT];
    printf("current grid scale: %lf\n",self.radarGrid.currentScale);
    [self.radarGrid setNeedsDisplay];

}
@end

#pragma mark - utility function definitions

void transformForTraj(CALayer *lay, double traj){
    CGPoint cent = lay.anchorPoint;
    CATransform3D trans = CATransform3DMakeRotation(traj, 0, 0, 1);
    lay.transform = trans;
}

// traj is in radians
CGPoint markerPosition(double traj, CGPoint center, double dist) {
    CGPoint markerPos;
    
    markerPos.y = -(cos(traj) * dist);
    markerPos.x = sin(traj) * dist;
    markerPos.y += center.y;
    markerPos.x += center.x;
    
    printf("return marker position (%lf,%lf)\n",markerPos.x,markerPos.y);
    return markerPos;
    
}


// NOTE: this path code was entirely (except the return statement) of this was generated by PaintCode
UIBezierPath *trajMarkerPath(UIColor *fillColor) {
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    //[bezierPath moveToPoint: CGPointMake(38.93, 96.76)];
    [bezierPath moveToPoint: CGPointMake(0.0, 19.78)];
    
    //[bezierPath addCurveToPoint: CGPointMake(46.9, 96.64) controlPoint1: CGPointMake(41.1, 96.69) controlPoint2: CGPointMake(43.84, 96.64)];
    [bezierPath addCurveToPoint: CGPointMake(7.97, 19.66) controlPoint1: CGPointMake(2.17, 19.71) controlPoint2: CGPointMake(4.91, 19.66)];
    
    //[bezierPath addCurveToPoint: CGPointMake(54.88, 96.76) controlPoint1: CGPointMake(49.96, 96.64) controlPoint2: CGPointMake(52.7, 96.69)];
    [bezierPath addCurveToPoint: CGPointMake(15.95, 19.78) controlPoint1: CGPointMake(11.03, 19.66) controlPoint2: CGPointMake(13.77, 19.71)];
    
    //[bezierPath addLineToPoint: CGPointMake(54.88, 76.98)];
    [bezierPath addLineToPoint: CGPointMake(15.95, 0)];
    
    //[bezierPath addLineToPoint: CGPointMake(46.9, 82.14)];
    [bezierPath addLineToPoint: CGPointMake(7.97, 5.16)];
    
    //[bezierPath addLineToPoint: CGPointMake(38.93, 76.98)];
    [bezierPath addLineToPoint: CGPointMake(0, 0)];
    
    
    //[bezierPath addLineToPoint: CGPointMake(38.93, 96.76)];
    [bezierPath addLineToPoint: CGPointMake(0, 19.78)];
    
    [bezierPath closePath];
    [fillColor setFill];
    [bezierPath fill];
    
    return bezierPath;
    
}

