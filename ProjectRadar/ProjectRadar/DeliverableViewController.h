//
//  DeliverableViewController.h
//  ProjectRadar
//
//  Created by BjornC on 5/4/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliverableViewController : UIViewController

// project deliverable belongs to
@property (weak, nonatomic) IBOutlet UIPickerView *projectSelector;

@property (weak, nonatomic) IBOutlet UITextField *delivName;
@property (weak, nonatomic) IBOutlet UITextView *DelivDesc;

// hours to complete deliverable
@property (weak, nonatomic) IBOutlet UIStepper *hoursToComp;
- (IBAction) modifyHoursToComplete:(UIStepper*)sender;
@property (weak, nonatomic) IBOutlet UILabel *hoursToCompleteText;

// due date
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDatePicker;

- (IBAction)saveDeliverable:(id)sender;

@end
