//
//  Project.h
//  
//
//  Created by BjornC on 6/8/15.
//
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Deliverable;

@interface Project : NSManagedObject

@property (nonatomic, retain) UIColor *projColor;
@property (nonatomic, retain) NSString * projDesc;
@property (nonatomic, retain) NSString * projName;
@property (nonatomic, retain) NSNumber * trajectRadian;
@property (nonatomic, retain) CAShapeLayer *markerLayer;
@property (nonatomic, retain) NSSet *deliverables;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)addDeliverablesObject:(Deliverable *)value;
- (void)removeDeliverablesObject:(Deliverable *)value;
- (void)addDeliverables:(NSSet *)values;
- (void)removeDeliverables:(NSSet *)values;

@end
