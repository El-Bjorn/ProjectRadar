//
//  ProjectManager.h
//  ProjectRadar
//
//  Created by BjornC on 4/10/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define PROJ_ENTITY @"Project"
#define DELIV_ENTITY @"Deliverable"


@interface ProjectManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)saveContext;
+(instancetype) sharedInstance;

-(void) addProjectWithName:(NSString*)name
                   andDesc:(NSString*)desc
                  andColor:(UIColor*)color
                andTraject:(double)traject;

-(void) addDeliverableWithTitle:(NSString*)title
                        andDesc:(NSString*)desc
                     andDueDate:(NSDate*)date
                   andHrsToComp:(double)hours;

-(NSArray*) allProjects;

-(NSArray*) allDeliverables;

-(NSArray*) allDeliverablesFromProj:(NSString*)proj;


@end
