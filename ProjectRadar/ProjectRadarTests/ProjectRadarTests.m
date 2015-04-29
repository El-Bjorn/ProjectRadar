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

@interface ProjectRadarTests : XCTestCase

@end

@implementation ProjectRadarTests

- (void)setUp {
    [super setUp];
   /* ProjectManager *pm = [ProjectManager sharedInstance];
    Project *p1 = [pm addProjectWithName:@"proj1"
                   andDesc:@"first project"
                  andColor:[UIColor redColor]
                andTraject:M_PI_4];
    
    Project *p2 = [pm addProjectWithName:@"proj2"
                   andDesc:@"second project"
                  andColor:[UIColor blueColor]
                andTraject:M_PI];
    
    [pm addDeliverableWithTitle:@"d1" andDesc:@"first deliv"
                     andDueDate:[[NSDate date] dateByAddingTimeInterval:40000] andHrsToComp:10.2 toProject:p1];
    
    [pm addDeliverableWithTitle:@"d2" andDesc:@"second deliv"
                     andDueDate:[[NSDate date] dateByAddingTimeInterval:86000] andHrsToComp:5.2 toProject:p2]; */

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
        [d coordsForScale:1.0];
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
