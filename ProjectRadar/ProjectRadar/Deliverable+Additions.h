//
//  Deliverable+Additions.h
//  ProjectRadar
//
//  Created by BjornC on 4/11/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//
#import "Deliverable.h"
#import <UIKit/UIKit.h>

@class Project;

@interface Deliverable (Additions)

// dep.
-(CALayer*) ballWithScale:(double)scale;

-(CALayer*) ballLayerWithScale:(double)scale inRect:(CGRect)rect;




// used to generate deliverable dot
-(CGPoint) coordsForScale:(double)scale;

@end
