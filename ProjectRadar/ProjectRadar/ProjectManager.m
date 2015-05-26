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

#define SQLITE_STORE_FILE @"ProjRadar.sqlite"
#define ICLOUD_STORE_FILE @"iCloud_ProjRadar.sqlite"
#define UBIQUITY_KEY @"ProjectRadar"

static ProjectManager *ourSharedInstance = nil;

@interface ProjectManager ()
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSPersistentStore *persistentStore;
@property (readonly, strong, nonatomic) NSPersistentStore *iCloudStore;

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
    //deliv.ballLayer = [deliv generateBallLayer];
    
    [self saveContext];
    
    return deliv;
}

-(void) deleteDeliverable:(Deliverable *)deliv {
    if (deliv==nil) {
        return;
    }
    [self.managedObjectContext deleteObject:deliv];
}


#pragma mark - Reading the Model

-(NSArray*) allProjects {
    NSError *err = nil;
    NSArray *projs = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:PROJ_ENTITY];
    NSSortDescriptor *projNameSort = [[NSSortDescriptor alloc] initWithKey:@"projName" ascending:YES];
    fetch.sortDescriptors = @[projNameSort];
    projs = [self.managedObjectContext executeFetchRequest:fetch error:&err];
    if (err) {
        NSLog(@"project fetch failed: %@",err);
    }
    return projs;
}

-(Project*) projWithName:(NSString *)name {
    NSError *err = nil;
    NSArray *projs = nil;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] initWithEntityName:PROJ_ENTITY];
    fetch.predicate = [NSPredicate predicateWithFormat:@"projName= %@",name];
    projs = [self.managedObjectContext executeFetchRequest:fetch error:&err];
    if (projs.count == 0) {
        NSLog(@"no project named: %@ found",name);
        return nil;
    }
    if (err) {
        NSLog(@"project fetch failed: %@",err);
        return nil;
    }
    return projs[0];
    
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
    
    // setup sqlite store
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:SQLITE_STORE_FILE];
    NSError *err = nil;
    /*_persistentStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                 configuration:nil URL:storeURL
                                                                       options:nil error:&err];
    if (self.persistentStore == nil) {
        NSLog(@"persistent store init failure: %@", err);
    } */

    // setup cloudkit store
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES,
                              NSPersistentStoreUbiquitousContentNameKey: UBIQUITY_KEY
                              };
    
    storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ProjectRadar-iCloud.sqlite"];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *cloudURL = [fm URLForUbiquityContainerIdentifier:nil];
    NSLog(@"cloud URL = %@",cloudURL);
    

    _iCloudStore = [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                 configuration:nil URL:storeURL
                                                                       options:options error:&err];
    if (self.iCloudStore){
        NSLog(@"cloud store configured at: %@",self.iCloudStore.URL.path);
    }
    if (self.iCloudStore == nil) {
        NSLog(@"cloud error: %@",err);
    } else {
        NSLog(@"cloud support added");
        NSFileManager *fm = [NSFileManager defaultManager];
        NSURL *cloudURL = [fm URLForUbiquityContainerIdentifier:UBIQUITY_KEY];
        NSLog(@"cloudURL = %@", cloudURL);
        id cloudToken = fm.ubiquityIdentityToken;
        NSLog(@"cloudToken = %@", cloudToken);
    }
    
    [self registerForStoreChangeNotifs];
    
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

#pragma mark - iCloud notifs

-(void) registerForStoreChangeNotifs {
    NSNotificationCenter *ns = [NSNotificationCenter defaultCenter];
    // will change
    [ns addObserver:self selector:@selector(storeWillChange:)
               name:NSPersistentStoreCoordinatorStoresWillChangeNotification
             object:self.persistentStoreCoordinator];
    // did change
    [ns addObserver:self selector:@selector(storeDidChange:)
               name:NSPersistentStoreCoordinatorStoresDidChangeNotification
             object:self.persistentStoreCoordinator];
    // imported cloudy stuff
    [ns addObserver:self selector:@selector(didImport_iCloudChanges:)
               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
            object:self.persistentStoreCoordinator];

}

-(void) storeWillChange:(NSNotification*)notif {
    NSLog(@"Core data will change++++++++++++++++++++++++++++++++++++++++++++");
    
}
-(void) storeDidChange:(NSNotification*)notif {
    NSLog(@"core data did change++++++++++++++++++++++++++++++++++++++++++++++");
}
-(void) didImport_iCloudChanges:(NSNotification*)notif {
    NSLog(@"got cloudy shit++++++++++++++++++++++++++++++++++++++++++++++++++++");
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSLog(@"ProjectManager saving context....");
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

#pragma mark - Project Picker


-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.allProjects.count;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0;
}

-(CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 500.0;
}

-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Project *p = self.allProjects[row];
    return p.projName;
}



@end

#pragma mark - Project additions


@implementation Project (Additions)

@end

#pragma mark - Deliverable additions

@implementation Deliverable (Additions)

#define HOUR_TO_PT_RATIO 1.5
#define MIN_BALL_SIZE 3.0   // 'cause it's bad if you can't see them

/*  Generated ball layer with correct size and trajectory (in unit square)
 *   position will be set later  */
-(CALayer*) generateBallLayer {
    CAShapeLayer *ballLayer = [CAShapeLayer layer];
    CGFloat ballSize = [self.hoursToComplete doubleValue] * HOUR_TO_PT_RATIO;
    printf("ball size: %lf\n",ballSize);
    if (ballSize < MIN_BALL_SIZE) {
        ballSize = MIN_BALL_SIZE;
    }
    //printf("deliv ball size= %lf\n",ballSize);
    ballLayer.bounds = CGRectMake(0, 0, ballSize, ballSize);
    ballLayer.opacity = 1.0;
    UIBezierPath *ballPath = [UIBezierPath bezierPathWithOvalInRect:ballLayer.bounds];
    ballPath.lineWidth = 1.0;
    ballLayer.path = ballPath.CGPath;
    ballLayer.strokeColor = self.parentProj.projColor.CGColor;
    ballLayer.fillColor = self.parentProj.projColor.CGColor;
    //self.ballLayer = ballLayer;
    
    return ballLayer;
}

#define SECS_PER_DAY (24*60*60)

-(void) repositionInRect:(CGRect)rect withScale:(double)scale {
    CGPoint rawCoords = [self coordsForScale:scale];
    CGPoint rectCenter = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    CGPoint transCoords = CGPointMake(rawCoords.x+(rect.size.width/2.0), rawCoords.y+(rect.size.height/2.0));
    /*if (self.ballLayer.superlayer == nil) {
        printf("AAHHHHHH balllayer has no superlayer! WTF!\n");
    } */
    self.ballLayer.position = transCoords;
    
    // check if the ball is in the radar screen
    CGFloat radarRadius = rect.size.width / 2.0; // width is as good as height
    
    if ( hypot(transCoords.x - rectCenter.x, transCoords.y - rectCenter.y) > radarRadius) {
        self.ballLayer.hidden = YES;
    } else {
        self.ballLayer.hidden = NO;
    }
}


// scale is rings/day
-(CGPoint) coordsForScale:(double)scale {
    double secs_til_due_date = [self.dueDate timeIntervalSinceDate:[NSDate date]];
    // in days
    double due_date_dist = secs_til_due_date / SECS_PER_DAY;
    // fudge
    due_date_dist += (due_date_dist * 0.5);
    double scaled_due_dist = due_date_dist * scale;
    // adjacent
    double y_pos = -(cos([self.parentProj.trajectRadian doubleValue])*scaled_due_dist);
    // opposite
    double x_pos = sin([self.parentProj.trajectRadian doubleValue])*scaled_due_dist;
    CGPoint pt = CGPointMake(x_pos, y_pos);
    
    return pt;
}



@end


