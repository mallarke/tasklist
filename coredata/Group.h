//
//  Group.h
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListItem;

@interface Group : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *items;
@end

@interface Group (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ListItem *)value;
- (void)removeItemsObject:(ListItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
