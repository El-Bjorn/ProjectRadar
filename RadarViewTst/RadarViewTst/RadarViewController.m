//
//  RadarViewController.m
//  RadarViewTst
//
//  Created by BjornC on 2/14/14.
//  Copyright (c) 2014 BjornC. All rights reserved.
//

#import "RadarViewController.h"

@interface RadarViewController ()

@end

@implementation RadarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepTimeButton:(id)sender {
    [self.radarViewScreen stepTimeForEvents];
}
@end
