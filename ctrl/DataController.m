//
//  DataController.m
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "DataController.h"

#import "Group.h"
#import "ListItem.h"

#pragma mark - NSSortDescriptor implementation -

@implementation NSSortDescriptor(CustomInit)

+ (NSSortDescriptor *)sortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
{
    return [[[self alloc] initWithKey:key ascending:ascending] autorelease];
}

@end

#pragma mark - DataController extension -

@interface DataController()

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly) NSURL *applicationDocumentsDirectory;

@end

#pragma mark - DataController implementation

@implementation DataController

static DataController *_singleton = nil;

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        [self managedObjectContext];
    }

    return self;
}

+ (id)sharedData
{
    @synchronized(self)
    {
        if(!_singleton)
        {
            _singleton = [DataController new];
        }
        
        return _singleton;
    }
}

- (void)dealloc
{
    self.managedObjectContext = nil;
    self.managedObjectModel = nil;
    self.persistentStoreCoordinator = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (Group *)createGroup:(NSString *)title
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    Group *group = [NSEntityDescription insertNewObjectForEntityForName:GROUP_KEY inManagedObjectContext:context];
    group.title = title;
    
    NSError *error = nil;
    [context save:&error];
    
    return (error == nil ? group : nil);
}

- (void)addItem:(NSString *)name toGroup:(Group *)group
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest object];
    request.entity = [NSEntityDescription entityForName:GROUP_KEY inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"title == %@", group.title];
    
    NSError *error = nil;
    NSArray *returnedObjects = [context executeFetchRequest:request error:&error];
    
    if(returnedObjects.count > 0 && !error)
    {
        Group *groupItem = [returnedObjects objectAtIndex:0];
        
        ListItem *item = [NSEntityDescription insertNewObjectForEntityForName:LIST_ITEM_KEY inManagedObjectContext:context];
        item.title = name;
        item.creationDate = [NSDate date];
        item.group = groupItem;
        
        [groupItem addItemsObject:item];
        
        [context save:&error];
    }
}

- (NSArray *)listItems:(NSManagedObjectID *)objectID
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest object];
    request.entity = [NSEntityDescription entityForName:LIST_ITEM_KEY inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"group == %@", [context objectWithID:objectID]];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false] ];
    
    NSError *error = nil;
    return [context executeFetchRequest:request error:&error];
}

- (void)saveDataContext
{
    NSError *error = nil;
    
    if(_managedObjectContext)
    {
        if([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        }
    }
}

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

- (NSArray *)groups
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest object];
    request.entity = [NSEntityDescription entityForName:GROUP_KEY inManagedObjectContext:context];
    request.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:TITLE_KEY ascending:true] ];
    
    NSError *error = nil;
    return [context executeFetchRequest:request error:&error];
}

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = self.persistentStoreCoordinator;
    if(coordinator)
    {
        _managedObjectContext = [NSManagedObjectContext new];
        _managedObjectContext.persistentStoreCoordinator = coordinator;
    }
    
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel)
    {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"list" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [self.applicationDocumentsDirectory URLByAppendingPathComponent:@"list.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

