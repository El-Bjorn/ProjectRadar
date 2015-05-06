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

//-(CALayer*) ballLayerWithScale:(double)scale inRect:(CGRect)rect;

-(CALayer*) generateBallLayer;

//-(CALayer*) setBallPositionInRect:(CGRect)rect withScale:(double)scale;
//-(CALayer*) ballLayerInRect:(CGRect)rect withScale:(double)scale;

-(void) repositionBallLayerInRect:(CGRect)rect withScale:(double)scale;


// used to generate deliverable dot
//-(CGPoint) coordsForScale:(double)scale;

@end
