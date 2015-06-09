//
//  RadarView.m
//  ProjectRadar
//
//  Created by BjornC on 5/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "RadarView.h"
#import "ProjectManager.h"

#pragma mark - utility functions
UIBezierPath *trajMarkerPath(UIColor *color);
CGPoint markerPosition(double traj, CGPoint center, double dist);
void transformForTraj(CALayer *lay, double traj);


@interface RadarView ()
@property (nonatomic,weak) Deliverable *selectedDeliv;
@end

/*#pragma mark - utility functions
UIBezierPath *trajMarkerPath(UIColor *color);
CGPoint markerPosition(double traj, CGPoint center, double dist); */

@implementation RadarView 

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"init RadarView");
        self.selectedDeliv = nil;
        self.userInteractionEnabled = YES;
    }
    return self;
}

#define TOUCHRECT_INSET -15.0

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    //printf("touch location: (%lf,%lf)\n",location.x,location.y);
    
    ProjectManager *pm = [ProjectManager sharedInstance];
    
    for (Deliverable *d in [pm allDeliverables]) {
        if (CGRectContainsPoint(CGRectInset(d.ballLayer.frame, TOUCHRECT_INSET, TOUCHRECT_INSET), location)) {
            NSLog(@"deliverable %@ contains point (%lf,%lf)",d,location.x,location.y);
            self.selectedDeliv = d;
            NSString *hrsStr = [NSString stringWithFormat:@"%@ hours",d.hoursToComplete];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:d.title message:hrsStr delegate:self cancelButtonTitle:@"ok" otherButtonTitles:@"delete",nil];
            [alert show];
            break;
        }
       // if ([d.ballLayer.presentationLayer containsPoint:location]) {
        //    NSLog(@"deliv %@ contains point",d);
        //}
    }
    
}

#define CANCEL_INDEX 0
#define DELETE_INDEX 1

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    printf("buttonIndex pressed: %ld\n",buttonIndex);
    if (buttonIndex == DELETE_INDEX) {
        ProjectManager *pm = [ProjectManager sharedInstance];
        [self.selectedDeliv.ballLayer removeFromSuperlayer];
        [pm deleteDeliverable:self.selectedDeliv];
    } else { // cancelling
        self.selectedDeliv = nil;
    }
    
}


#pragma mark - May I present...drawRect

#define MARKER_SIZE 20.0

/*-(void) drawProjMarkers {
    ProjectManager *pm = [ProjectManager sharedInstance];
    
    
} */
#define MARKER_X_SIZE 15.95
#define MARKER_Y_SIZE 19.78


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //NSLog(@"calling drawRect");
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *delivs = [pm allDeliverables];
    
    // clear and re-add the sublayers
    //self.layer.sublayers = nil;
    
    for (Deliverable *d in delivs) {
        if (d.ballLayer == nil) {
            NSLog(@"adding new ball layer in drawrect");
            d.ballLayer = [d generateBallLayer];
            [self.layer addSublayer:d.ballLayer];

        }
        [d repositionInRect:self.bounds withScale:self.currentScale];
    }
    // trajectory markers
    //CGRect r = self.bounds;
    for (Project *p in [pm allProjects]) {
        if (p.markerLayer == nil) {
            NSLog(@"adding proj markerlayer in drawrect");
            CAShapeLayer *markerLayer = [CAShapeLayer layer];
            p.markerLayer = markerLayer;
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
            
            [self.layer addSublayer:markerLayer];
        }
    }
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
        [bezierPath moveToPoint: CGPointMake(0.0, 19.78)];
        [bezierPath addCurveToPoint: CGPointMake(7.97, 19.66) controlPoint1: CGPointMake(2.17, 19.71) controlPoint2: CGPointMake(4.91, 19.66)];
        [bezierPath addCurveToPoint: CGPointMake(15.95, 19.78) controlPoint1: CGPointMake(11.03, 19.66) controlPoint2: CGPointMake(13.77, 19.71)];
        [bezierPath addLineToPoint: CGPointMake(15.95, 0)];
        [bezierPath addLineToPoint: CGPointMake(7.97, 5.16)];
        [bezierPath addLineToPoint: CGPointMake(0, 0)];
        [bezierPath addLineToPoint: CGPointMake(0, 19.78)];
        [bezierPath closePath];
        
        return bezierPath;
        
    }
    

