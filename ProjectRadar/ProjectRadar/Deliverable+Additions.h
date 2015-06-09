//
//  Deliverable+Additions.h
//  ProjectRadar
//
//  Created by BjornC on 4/11/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//
/*
 @class Project;
 
 @interface Deliverable : NSManagedObject
 
 @property (nonatomic, retain) CALayer *ballLayer;
 @property (nonatomic, retain) NSString * detailDesc;
 @property (nonatomic, retain) NSDate * dueDate;
 @property (nonatomic, retain) NSNumber * hoursToComplete;
 @property (nonatomic, retain) NSString * title;
 @property (nonatomic, retain) Project *parentProj;
 
 @end

 */
#import "Deliverable.h"
#import <UIKit/UIKit.h>

@class Project;

@interface Deliverable (Additions)

-(CALayer*) generateBallLayer;

-(void) repositionInRect:(CGRect)rect withScale:(double)scale;


@end
