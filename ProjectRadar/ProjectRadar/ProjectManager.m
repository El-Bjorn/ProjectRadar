//
//  ProjectManager.m
//  ProjectRadar
//
//  Created by BjornC on 4/10/15.
//  Copyright (c) 2015 Builtlight. All rights reserved.
//

#import "ProjectManager.h"
#import "Project+Additions.h"
#import "Deliverable+Additions.h"

static ProjectManager *ourSharedInstance = nil;

@interface ProjectManager ()
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation ProjectManager

-(instancetype) init {
    self = [super init];
    if (self) {
        NSLog(@"initializing ProjectManager");
        
    }
    return self;
}

+(instancetype) sharedInstance {
    if (ourSharedInstance == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            ourSharedInstance = [[ProjectManager alloc] init];
        });
        if (ourSharedInstance == nil) {
            NSLog(@"Can't create share instance...bailing...");
            assert(0);
        }
    }
    return ourSharedInstance;
}

#pragma mark - model manipulation (Projects)

-(Project*) addProjectWithName:(NSString*)name
                   andDesc:(NSString*)desc
                  andColor:(UIColor*)color
                andTraject:(double)traject
{
    Project *proj = [NSEntityDescription insertNewObjectForEntityForName:PROJ_ENTITY
                                                  inManagedObjectContext:self.managedObjectContext];
    proj.projName = name;
    proj.projDesc = desc;
    proj.projColor = color;
    proj.trajectRadian = @(traject);
    [self saveContext];
    
    return proj;
}

-(void) deleteProject:(Project *)proj {
    // delete all the deliverables
    NSArray *delivs = [self allDeliverablesFromProj:proj];
    for (Deliverable *d in delivs) {
        [self.managedObjectContext deleteObject:d];
    }
    // delete the project
    [self.managedObjectContext deleteObject:proj];
    [self saveContext];
    
}

#pragma mark - model manipulation (Deliverables)

-(Deliverable*) addDeliverableWithTitle:(NSString*)title
                        andDesc:(NSString*)desc
                     andDueDate:(NSDate*)date
                   andHrsToComp:(double)hours
                    toProject:(Project *)proj
{
    Deliverable *deliv = [NSEntityDescription insertNewObjectForEntityForName:DELIV_ENTITY
                                                       inManagedObjectContext:self.managedObjectContext];
    deliv.title = title;
    deliv.detailDesc = desc;
    deliv.dueDate = date;
    deliv.hoursToComplete = @(hours);
    deliv.parentProj = proj;
    [deliv generateBallLayer];
    
    [self saveContext];
    
    return deliv;
}

-(void) deleteDeliverable:(Deliverable *)deliv {
    [self.managedObjectContext deleteObject:deliv];
    [self saveContext];
}


#pragma mark - Reading the Model

-(NSArray*) allProjects {
    NSError *err = nil;
    NSArray *projs = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:PROJ_ENTITY];
    projs = [self.managedObjectContext executeFetchRequest:fetch error:&err];
    if (err) {
        NSLog(@"project fetch failed: %@",err);
    }
    return projs;
}

-(NSArray*) allDeliverables {
    NSError *err = nil;
    NSArray *delivs = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:DELIV_ENTITY];
    delivs = [self.managedObjectContext executeFetchRequest:fetch error:&err];
    if (err) {
        NSLog(@"deliverable fetch failed: %@",err);
    }
    return delivs;
}

-(NSArray*) allDeliverablesFromProj:(Project*)proj {
    NSError *err = nil;
    NSArray *delivs = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:DELIV_ENTITY];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"parentProj= %@",proj];
    fetch.predicate = pred;
    delivs = [self.managedObjectContext executeFetchRequest:fetch error:&err];
    if (err) {
        NSLog(@"deliverable fetch failed: %@",err);
    }
    return delivs;
}




#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator; 

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.builtlight.ProjectRadar" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ProjectRadar" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProjectRadar.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end

#pragma mark - Project additions


@implementation Project (Additions)

@end

#pragma mark - Deliverable additions

@implementation Deliverable (Additions)

#define HOUR_TO_PT_RATIO 1.0

/*  Generated ball layer with correct size and trajectory (in unit square)
 *   position will be set later  */
-(CALayer*) generateBallLayer {
    CAShapeLayer *ballLayer = [CAShapeLayer layer];
    CGFloat ballSize = [self.hoursToComplete doubleValue] * HOUR_TO_PT_RATIO;
    printf("deliv ball size= %lf\n",ballSize);
    ballLayer.bounds = CGRectMake(0, 0, ballSize, ballSize);
    ballLayer.opacity = 1.0;
    UIBezierPath *ballPath = [UIBezierPath bezierPathWithOvalInRect:ballLayer.bounds];
    ballPath.lineWidth = 1.0;
    ballLayer.path = ballPath.CGPath;
    ballLayer.strokeColor = self.parentProj.projColor.CGColor;
    ballLayer.fillColor = self.parentProj.projColor.CGColor;
    self.ballLayer = ballLayer;
    
    return ballLayer;
}

#define SECS_PER_DAY (24*60*60)

-(CALayer*) setBallPositionInRect:(CGRect)rect withScale:(double)scale {
    // scaled, but not translated
    CGPoint rawCoords = [self coordsForScale:scale];
    CGPoint transCoords = CGPointMake(rawCoords.x+(rect.size.width/2.0), rawCoords.y+(rect.size.height/2.0));
    self.ballLayer.position = transCoords;
    
    return self.ballLayer;
}


// scale is rings/day
-(CGPoint) coordsForScale:(double)scale {
    double secs_til_due_date = [self.dueDate timeIntervalSinceDate:[NSDate date]];
    // in days
    double due_date_dist = secs_til_due_date / SECS_PER_DAY;
    // scaled distance in radar rings (this is our hypotenuse)
    double scaled_due_dist = due_date_dist * scale;
    printf("scaled distance: %lf\n", scaled_due_dist);
    double traject = [self.parentProj.trajectRadian doubleValue];
    printf("trajectory in degrees: %lf\n",(360*traject)/(2*M_PI));
    // adjacent
    double y_pos = -(cos([self.parentProj.trajectRadian doubleValue])*scaled_due_dist);
    printf("y pos: %lf\n",y_pos);
    // opposite
    double x_pos = sin([self.parentProj.trajectRadian doubleValue])*scaled_due_dist;
    printf("x pos: %lf\n",x_pos);
    
    CGPoint pt = CGPointMake(x_pos, y_pos);
    
    return pt;
}

/*
-(CALayer*) ballLayerWithScale:(double)scale inRect:(CGRect)rect {
    CAShapeLayer *ballLayer = [CAShapeLayer layer];
    CGFloat ballSize = [self.hoursToComplete doubleValue] * (50.0/scale);
    printf("deliv ball size= %lf\n",ballSize);

    ballLayer.bounds = CGRectMake(0, 0, ballSize, ballSize);
    ballLayer.opacity = 1.0;
    // scaled, but not translated
    CGPoint rawCoords = [self coordsForScale:scale];
    CGPoint transCoords = CGPointMake(rawCoords.x+(rect.size.width/2.0), rawCoords.y+(rect.size.height/2.0));
    printf("ball coordinates: (%lf,%lf)\n",transCoords.x,transCoords.y);
    ballLayer.position = transCoords;
    UIBezierPath *ballPath = [UIBezierPath bezierPathWithOvalInRect:ballLayer.bounds];
    ballPath.lineWidth = 1.0;
    ballLayer.path = ballPath.CGPath;
    ballLayer.strokeColor = self.parentProj.projColor.CGColor;
    ballLayer.fillColor = self.parentProj.projColor.CGColor;
    
    return ballLayer;
} */



/* generates a ball of the proper size and color
 *  suitable for display in the radarview 
 * re. scale: at 1x, 1pt = 1hr
 */
/*-(CALayer*) ballWithScale:(double)scale {
    CAShapeLayer *ballLayer = [CAShapeLayer layer];
    CGFloat ballSize = [self.hoursToComplete doubleValue] * (1.0/scale);
    printf("deliv ball size= %lf\n",ballSize);
    
    ballLayer.bounds = CGRectMake(0, 0, ballSize, ballSize);
    ballLayer.opacity = 1.0;
    //ballLayer.position = [self coordsForScale:scale];
    ballLayer.position = CGPointMake(100, 100);
    UIBezierPath *ballPath = [UIBezierPath bezierPathWithOvalInRect:ballLayer.bounds];
    ballPath.lineWidth = 1.0;
    ballLayer.path = ballPath.CGPath;
    ballLayer.strokeColor = self.parentProj.projColor.CGColor;
    ballLayer.fillColor = self.parentProj.projColor.CGColor;
    
    return ballLayer;
} */




@end




