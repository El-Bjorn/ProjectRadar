//
//  RadarView.m
//  ProjectRadar
//
//  Created by BjornC on 5/5/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "RadarView.h"
#import "ProjectManager.h"

@implementation RadarView

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"init RadarView");
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    printf("touch location: (%lf,%lf)\n",location.x,location.y);
    
    ProjectManager *pm = [ProjectManager sharedInstance];
    
    /*CALayer *hitLayer = [self.layer.presentationLayer hitTest:location];
    if (hitLayer) {
        NSLog(@"got hit: %@",hitLayer);
    } */
    
    for (Deliverable *d in [pm allDeliverables]) {
        if (CGRectContainsPoint(d.ballLayer.frame, location)) {
            NSLog(@"deliv contains point");
        }
       // if ([d.ballLayer.presentationLayer containsPoint:location]) {
        //    NSLog(@"deliv %@ contains point",d);
        //}
    }
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //NSLog(@"calling drawRect");
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *delivs = [pm allDeliverables];
    
    for (Deliverable *d in delivs) {
        [d repositionBallLayerInRect:self.bounds withScale:self.currentScale];
        //NSLog(@"deliv layer %@",d);
        printf("deliv layer frame (%lf,%lf) w= %lf h= %lf\n",d.ballLayer.frame.origin.x,d.ballLayer.frame.origin.y,d.ballLayer.frame.size.width,d.ballLayer.frame.size.height);
    }
}


@end
