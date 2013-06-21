//
//  DataController.h
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Group;
@class ListItem;

#pragma mark - NSSortDescriptor category -

@interface NSSortDescriptor(CustomInit)

+ (NSSortDescriptor *)sortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending;

@end

@interface DataController : NSObject

@property (readonly) NSArray *groups;

+ (DataController *)sharedData;

- (Group *)createGroup:(NSString *)title;
- (void)addItem:(NSString *)name toGroup:(Group *)group;

- (NSArray *)listItems:(NSManagedObjectID *)objectID;

- (void)saveDataContext;

@end
