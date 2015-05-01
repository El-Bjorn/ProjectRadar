//
//  ProjectRadarTests.m
//  ProjectRadarTests
//
//  Created by BjornC on 4/10/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ProjectManager.h"
#import "Deliverable+Additions.h"

@interface ProjectRadarTests : XCTestCase

@end

@implementation ProjectRadarTests

- (void)setUp {
    [super setUp];
    // /*
    ProjectManager *pm = [ProjectManager sharedInstance];
    Project *p1 = [pm addProjectWithName:@"proj1"
                   andDesc:@"first project"
                  andColor:[UIColor redColor]
                andTraject:0];
    
    Project *p2 = [pm addProjectWithName:@"proj2"
                   andDesc:@"second project"
                  andColor:[UIColor blueColor]
                andTraject:M_PI/2];
    
    Project *p3 = [pm addProjectWithName:@"proj2"
                                 andDesc:@"second project"
                                andColor:[UIColor yellowColor]
                              andTraject:M_PI];
    Project *p4 = [pm addProjectWithName:@"proj2"
                                 andDesc:@"second project"
                                andColor:[UIColor greenColor]
                              andTraject:(1.5*M_PI)];

    
    [pm addDeliverableWithTitle:@"d1" andDesc:@"first deliv"
                     andDueDate:[[NSDate date] dateByAddingTimeInterval:10000] andHrsToComp:10.2 toProject:p1];
    
    [pm addDeliverableWithTitle:@"d2" andDesc:@"second deliv"
                     andDueDate:[[NSDate date] dateByAddingTimeInterval:36000] andHrsToComp:20 toProject:p2];
    
    [pm addDeliverableWithTitle:@"d3" andDesc:@"first deliv"
                     andDueDate:[[NSDate date] dateByAddingTimeInterval:40000] andHrsToComp:30 toProject:p3];
    
    [pm addDeliverableWithTitle:@"d4" andDesc:@"first deliv"
                     andDueDate:[[NSDate date] dateByAddingTimeInterval:20000] andHrsToComp:40 toProject:p4];

    //*/

}

-(void) testDelivBallLayers {
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *delivs = [pm allDeliverables];
    for (Deliverable *d in delivs) {
        //NSLog(@"layer for deliverable: %@",[d setBallPositionInRect:<#(CGRect)#> withScale:<#(double)#>);
    }
}

-(void) testDegreesRadians {
    float degrees = 45.0;
    float radians = 2.5;
    
    printf("%f degrees = %f radians\n",degrees,RADIANS(degrees));
    printf("%f radians = %f degrees\n",radians,DEGREES(radians));
}

/*-(void) testAddDeliverable {
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *allProjs = [pm allProjects];
    Project *p = allProjs[0];
    
} */

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void) testCoords {
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *delivs = [pm allDeliverables];
    for (Deliverable *d in delivs) {
        NSLog(@"Coords for deliverable: %@",d);
        //[d coordsForScale:1.0];
    }
}

-(void) testBasics {
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSLog(@"all projects: %@",[pm allProjects]);
    NSLog(@"all deliverable: %@",[pm allDeliverables]);
}

-(void) testDelivSelect {
    ProjectManager *pm = [ProjectManager sharedInstance];
    NSArray *allProjs = [pm allProjects];
    Project *proj = allProjs[0];
    NSLog(@"delivs for project %@: %@",proj.projName,[pm allDeliverablesFromProj:proj]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
