//
//  Deliverable.h
//  ProjectRadar
//
//  Created by BjornC on 4/10/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Deliverable : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSString * detailDesc;
@property (nonatomic, retain) NSNumber * hoursToComplete;
@property (nonatomic, retain) Project *parentProj;

@end
