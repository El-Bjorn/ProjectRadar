//
//  ProjectViewController.m
//  ProjectRadar
//
//  Created by BjornC on 5/4/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "ProjectViewController.h"
#import "ProjectManager.h"

@interface ProjectViewController ()
@property (nonatomic,strong) NSArray *projectColors;
@end

static int colorIndex = 0;

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.projectColors = @[ [UIColor redColor],
                            [UIColor lightGrayColor],
                            [UIColor purpleColor],
                            [UIColor blueColor],
                            [UIColor whiteColor],
                            [UIColor yellowColor],
                            [UIColor orangeColor],
                            [UIColor cyanColor],
                            [UIColor greenColor]
                        ];
    self.colorToggleButton.backgroundColor = self.projectColors[colorIndex];
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

- (IBAction)trajectoryAdjusted:(UISlider*)sender {
    [self.projectNameField resignFirstResponder];
    [self.projDescField resignFirstResponder];
    self.currentTrajectory.text = [NSString stringWithFormat:@"%d",(int)sender.value];
}
- (IBAction)colorToggle:(id)sender {
    colorIndex = (colorIndex+1) % self.projectColors.count;
    self.colorToggleButton.backgroundColor = self.projectColors[colorIndex];
    
    NSLog(@"toggling color");
}

- (IBAction)saveProject:(id)sender {
    NSLog(@"saving project: %@",self.projectNameField.text);
    ProjectManager *pm = [ProjectManager sharedInstance];
    [pm addProjectWithName:self.projectNameField.text andDesc:self.projDescField.text andColor:self.colorToggleButton.backgroundColor andTraject:RADIANS(self.trajectorySlider.value)];
}
@end
