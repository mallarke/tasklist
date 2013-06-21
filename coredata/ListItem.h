//
//  ListItem.h
//  list
//
//  Created by mallarke on 6/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Group;

@interface ListItem : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) Group *group;

@end
