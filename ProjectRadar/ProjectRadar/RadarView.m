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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //NSLog(@"calling drawRect");
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *delivs = [pm allDeliverables];
    
    for (Deliverable *d in delivs) {
        [d repositionBallLayerInRect:self.bounds withScale:self.currentScale];
    }
}


@end
