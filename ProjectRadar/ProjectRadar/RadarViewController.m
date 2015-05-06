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

@end

@implementation RadarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.radarGrid.currentScale = 100.0;
    
    ProjectManager *pm = [ProjectManager sharedInstance];
    
    NSArray *delivs = [pm allDeliverables];
    for (Deliverable *d in delivs) {
        CALayer *sublay = [d generateBallLayer];
        [d repositionBallLayerInRect:self.radarGrid.bounds withScale:self.radarGrid.currentScale];
        [self.radarGrid.layer addSublayer:sublay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender {
    NSLog(@"pinched! ouch! scale= %lf",sender.scale);
    if (sender.scale < 1.0) {
        self.radarGrid.currentScale -= 20;
    } else {
        self.radarGrid.currentScale += 20;
    }
    [self.radarGrid setNeedsDisplay];

}
@end
