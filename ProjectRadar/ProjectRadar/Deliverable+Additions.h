//
//  Deliverable+Additions.h
//  ProjectRadar
//
//  Created by BjornC on 4/11/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//
#import "Deliverable.h"

@class Project;

@interface Deliverable (Additions)

-(void) addToProject:(Project*)proj;
-(void) removeFromProject:(Project*)proj;

-(CGPoint) coordsForScale:(double)scale;

@end
