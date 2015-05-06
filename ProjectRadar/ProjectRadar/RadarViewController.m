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

@implementation RadarViewController

#define SCALE_VALUE @"scaleValue"
#define SCALE_TEXT  @"scaleText"

- (void)viewDidLoad {
    [super viewDidLoad];
    self.current_scale_index = 0;
    [self setupScalingTable];
    self.radarGrid.currentScale = [self.scalingTable[self.current_scale_index][SCALE_VALUE] doubleValue];
    
    ProjectManager *pm = [ProjectManager sharedInstance];
    
    NSArray *delivs = [pm allDeliverables];
    for (Deliverable *d in delivs) {
        CALayer *sublay = [d generateBallLayer];
        [d repositionBallLayerInRect:self.radarGrid.bounds withScale:self.radarGrid.currentScale];
        [self.radarGrid.layer addSublayer:sublay];
    }
}

-(void) setupScalingTable {
    self.scalingTable = @[ @{SCALE_TEXT: @"12 hours", SCALE_VALUE: @(30.0)},
                           @{ SCALE_TEXT: @"1 Day", SCALE_VALUE: @(15.0) },
                           @{ SCALE_TEXT: @"2 Days", SCALE_VALUE: @(7.2) },
                           @{ SCALE_TEXT: @"3 Days", SCALE_VALUE: @(4.5) },
                           @{ SCALE_TEXT: @"7 Days", SCALE_VALUE: @(2.0) },
                           @{ SCALE_TEXT: @"14 Days",SCALE_VALUE: @(0.9) }
                           ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender {
    NSLog(@"pinched! ouch! velocity = %lf",sender.velocity);
    if (fabs(sender.velocity)  > 1) {
        return;
    }
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
    [self.radarGrid setNeedsDisplay];

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
