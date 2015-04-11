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
    /*ProjectManager *pm = [ProjectManager sharedInstance];
    Project *p1 = [pm addProjectWithName:@"proj1"
                   andDesc:@"first project"
                  andColor:[UIColor redColor]
                andTraject:1.5];
    
    Project *p2 = [pm addProjectWithName:@"proj2"
                   andDesc:@"second project"
                  andColor:[UIColor blueColor]
                andTraject:5.5];
    
    [pm addDeliverableWithTitle:@"d1" andDesc:@"first deliv"
                     andDueDate:[NSDate date] andHrsToComp:15.2 toProject:p1];
    
    [pm addDeliverableWithTitle:@"d2" andDesc:@"second deliv"
                     andDueDate:[NSDate date] andHrsToComp:15.2 toProject:p2]; */

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testBasics {
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
