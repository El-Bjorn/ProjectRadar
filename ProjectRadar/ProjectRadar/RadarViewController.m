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
    
    ProjectManager *pm = [ProjectManager sharedInstance];
    
    NSArray *delivs = [pm allDeliverables];
    for (Deliverable *d in delivs) {
        CALayer *sublay = [d ballLayerWithScale:75.0 inRect:self.view.bounds];
        [self.view.layer addSublayer:sublay];
    }
    
    
    
    //self.view.backgroundColor = [UIColor redColor]; // sanity test
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
