//
//  ProjectViewController.h
//  ProjectRadar
//
//  Created by BjornC on 5/4/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *projectNameField;
@property (weak, nonatomic) IBOutlet UITextView *projDescField;
@property (weak, nonatomic) IBOutlet UILabel *currentTrajectory;
-(IBAction)trajectoryAdjusted:(UISlider *)sender;
@property (weak, nonatomic) IBOutlet UISlider *trajectorySlider;

@property (weak, nonatomic) IBOutlet UIButton *colorToggleButton;
- (IBAction)colorToggle:(id)sender;
- (IBAction)saveProject:(id)sender;

@end
