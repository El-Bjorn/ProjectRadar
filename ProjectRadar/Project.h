//
//  Project.h
//  ProjectRadar
//
//  Created by BjornC on 4/10/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface Project : NSManagedObject

@property (nonatomic, retain) NSString * projName;
@property (nonatomic, retain) NSString * projDesc;
@property (nonatomic, retain) NSNumber * trajectRadian;
@property (nonatomic, retain) UIColor *projColor;
@property (nonatomic, retain) NSSet *deliverables;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addDeliverablesObject:(NSManagedObject *)value;
- (void)removeDeliverablesObject:(NSManagedObject *)value;
- (void)addDeliverables:(NSSet *)values;
- (void)removeDeliverables:(NSSet *)values;

@end
