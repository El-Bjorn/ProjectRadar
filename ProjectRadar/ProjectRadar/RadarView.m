//
//  RadarView.m
//  ProjectRadar
//
//  Created by BjornC on 5/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "RadarView.h"
#import "ProjectManager.h"

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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:d.title message:@"Confirm delete?" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"delete",nil];
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //NSLog(@"calling drawRect");
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *delivs = [pm allDeliverables];
    
    for (Deliverable *d in delivs) {
        [d repositionInRect:self.bounds withScale:self.currentScale];
    }
    
}


@end

