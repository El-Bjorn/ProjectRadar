//
//  DeliverableViewController.m
//  ProjectRadar
//
//  Created by BjornC on 5/4/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "DeliverableViewController.h"
#import "ProjectManager.h"

@interface DeliverableViewController ()

@end

@implementation DeliverableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    ProjectManager *pm = [ProjectManager sharedInstance];
    
    self.projectSelector.dataSource = pm;
    self.projectSelector.delegate = pm;
    
    // hours stepper
    self.hoursToComp.minimumValue = 0;
    self.hoursToComp.maximumValue = 80;
    self.hoursToComp.stepValue = 0.5;
    self.hoursToCompleteText.text = [NSString stringWithFormat:@"%.1lf",self.hoursToComp.value];
    
    //self.projectSelector.numberOfComponents
    
    
    //self.projectSelector
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveDeliverable:(id)sender {
    ProjectManager *pm = [ProjectManager sharedInstance];
    long projIndex = [self.projectSelector selectedRowInComponent:0];
    
    [pm addDeliverableWithTitle:self.delivName.text andDesc:self.DelivDesc.text andDueDate:self.dueDatePicker.date andHrsToComp:self.hoursToComp.value toProject:pm.allProjects[projIndex]];
}
- (IBAction)modifyHoursToComplete:(UIStepper*)sender {
    NSLog(@"stepper = %@",sender);
    self.hoursToCompleteText.text = [NSString stringWithFormat:@"%.1lf",self.hoursToComp.value];
}
@end
