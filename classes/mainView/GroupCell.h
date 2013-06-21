//
//  GroupCell.h
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "TableViewCell.h"

@interface GroupCell : TableViewCell

@property (nonatomic, retain) Group *group;

+ (CGFloat)heightForGroup:(Group *)group;

@end

