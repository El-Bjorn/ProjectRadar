//
//  ViewController.h
//  ProjectRadar
//
//  Created by BjornC on 4/10/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadarView.h"

@interface RadarViewController : UIViewController

- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender;
- (IBAction)tappedRadar:(UITapGestureRecognizer *)sender;

@property (nonatomic,weak) IBOutlet RadarView *radarGrid;
@property (weak, nonatomic) IBOutlet UILabel *scaleLabel;

@end

