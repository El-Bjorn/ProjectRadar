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

#pragma mark - utility functions
UIBezierPath *trajMarkerPath(UIColor *color);
CGPoint markerPosition(double traj, CGPoint center, double dist);
void transformForTraj(CALayer *lay, double traj);


@implementation RadarViewController

#define SCALE_VALUE @"scaleValue"
#define SCALE_TEXT  @"scaleText"
#define SCALE_RANGE @"scaleRange" // how many days out are on the radar screen

- (void)viewDidLoad {
    [super viewDidLoad];
    self.current_scale_index = 2;
    [self setupScalingTable];
    self.radarGrid.currentScale = [self.scalingTable[self.current_scale_index][SCALE_VALUE] doubleValue];
    self.scaleLabel.text = self.scalingTable[self.current_scale_index][SCALE_TEXT];
    
    [self setDateRangeString];
    
    [self registerForStoreChangeNotifs];
}

#define MARKER_X_SIZE 15.95
#define MARKER_Y_SIZE 19.78

-(void) viewDidAppear:(BOOL)animated {
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *delivs = [pm allDeliverables];
    
    self.radarGrid.layer.sublayers = nil;
    
    for (Deliverable *d in delivs) {
        d.ballLayer = [d generateBallLayer];
        [self.radarGrid.layer addSublayer:d.ballLayer];
        [d repositionInRect:self.radarGrid.bounds withScale:self.radarGrid.currentScale];
    }
    // trajectory markers
    CGRect rect = self.radarGrid.bounds;
    for (Project *p in [pm allProjects]) {
        CAShapeLayer *markerLayer = [CAShapeLayer layer];
        p.markerLayer = markerLayer;
        //markerLayer.backgroundColor = [UIColor blueColor].CGColor;
        markerLayer.hidden = NO;
        markerLayer.bounds = CGRectMake(0, 0, MARKER_X_SIZE, MARKER_Y_SIZE);
        markerLayer.opacity = 1.0;
        markerLayer.path = trajMarkerPath(p.projColor).CGPath;
        markerLayer.fillColor = p.projColor.CGColor;
        //markerLayer.path = trajMarkerPath([UIColor redColor]).CGPath;
        
        markerLayer.position = markerPosition([p.trajectRadian doubleValue],
                                              CGPointMake(rect.size.width/2.0, rect.size.height/2.0),
                                              rect.size.width/2.0-5);
        transformForTraj(markerLayer, [p.trajectRadian doubleValue]);
        
        [self.radarGrid.layer addSublayer:markerLayer];
    } 
    
}

-(void) setDateRangeString {
    NSDateFormatter  *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSDate *currDate = [NSDate date];
    NSString *currDateString = [dateFormat stringFromDate:currDate];
    double num_days = [self.scalingTable[self.current_scale_index][SCALE_RANGE] doubleValue];
    NSDate *outerRingDate = [currDate dateByAddingTimeInterval:60*60*24*num_days];
    NSString *outerDateString = [dateFormat stringFromDate:outerRingDate];
    
    //self.currentDateRange.text = [NSString stringWithFormat:@"%@ - %@",currDateString,outerDateString];
    self.currentDateRange.text = [NSString stringWithFormat:@"Deliverables through %@",outerDateString];
}

-(void) setupScalingTable {
    self.scalingTable = @[ @{SCALE_TEXT: @"6 hours", SCALE_VALUE: @(60.0), SCALE_RANGE: @(2) },
                           @{SCALE_TEXT: @"12 hours", SCALE_VALUE: @(30.0), SCALE_RANGE: @(4) },
                           @{ SCALE_TEXT: @"1 Day", SCALE_VALUE: @(15.0), SCALE_RANGE: @(7) },
                           @{ SCALE_TEXT: @"2 Days", SCALE_VALUE: @(7.2), SCALE_RANGE: @(14) },
                           @{ SCALE_TEXT: @"3 Days", SCALE_VALUE: @(4.5), SCALE_RANGE: @(21) },
                           @{ SCALE_TEXT: @"7 Days", SCALE_VALUE: @(2.0), SCALE_RANGE: @(49) },
                           @{ SCALE_TEXT: @"14 Days",SCALE_VALUE: @(0.9), SCALE_RANGE: @(98) },
                           @{ SCALE_TEXT: @"1 Month",SCALE_VALUE: @(0.45), SCALE_RANGE: @(196) },
                           @{ SCALE_TEXT: @"2 Months", SCALE_VALUE: @(0.225), SCALE_RANGE: @(392) }
                           ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pinchGesture:(UIPinchGestureRecognizer *)sender {
    static BOOL pinchLock = NO;
    if (pinchLock == NO) {
        //NSLog(@"pinched! ouch! velocity = %lf",sender.velocity);
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
        
        [self setDateRangeString];
        
        pinchLock = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //NSLog(@"reenabling pinch");
            //sender.enabled = YES;
            pinchLock = NO;
        });
        [self.radarGrid setNeedsDisplay];

    }
    
    

}

// disabled
- (IBAction)tappedRadar:(UITapGestureRecognizer *)sender {
    self.current_scale_index = (self.current_scale_index+1)%self.scalingTable.count;
    NSLog(@"got tap");
    self.radarGrid.currentScale = [self.scalingTable[self.current_scale_index][SCALE_VALUE] doubleValue];
    self.scaleLabel.text = self.scalingTable[self.current_scale_index][SCALE_TEXT];
    printf("current grid scale: %lf\n",self.radarGrid.currentScale);
    [self.radarGrid setNeedsDisplay];

}

#pragma mark - iCloud notifs

-(void) registerForStoreChangeNotifs {
    NSNotificationCenter *ns = [NSNotificationCenter defaultCenter];
    // will change
    [ns addObserver:self selector:@selector(storeWillChange:)
               name:NSPersistentStoreCoordinatorStoresWillChangeNotification
             object:nil];
    // did change
    [ns addObserver:self selector:@selector(storeDidChange:)
               name:NSPersistentStoreCoordinatorStoresDidChangeNotification
             object:nil];
    // imported cloudy stuff
    [ns addObserver:self selector:@selector(didImport_iCloudChanges:)
               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
             object:nil];
    
}

-(void) storeWillChange:(NSNotification*)notif {
    NSLog(@"Core data will change++++++++++++++++++++++++++++++++++++++++++++");
    
}
-(void) storeDidChange:(NSNotification*)notif {
    NSLog(@"core data did change++++++++++++++++++++++++++++++++++++++++++++++");
    [self.radarGrid setNeedsDisplay];
}
-(void) didImport_iCloudChanges:(NSNotification*)notif {
    NSLog(@"got cloudy shit++++++++++++++++++++++++++++++++++++++++++++++++++++");
}



@end


