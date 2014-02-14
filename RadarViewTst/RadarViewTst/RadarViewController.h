//
//  RadarViewController.h
//  RadarViewTst
//
//  Created by BjornC on 2/14/14.
//  Copyright (c) 2014 BjornC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadarView.h"

@interface RadarViewController : UIViewController
- (IBAction)stepTimeButton:(id)sender;
@property (weak, nonatomic) IBOutlet RadarView *radarViewScreen;

@end
