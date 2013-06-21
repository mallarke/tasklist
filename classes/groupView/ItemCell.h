//
//  ItemCell.h
//  list
//
//  Created by mallarke on 6/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "TableViewCell.h"

@interface ItemCell : TableViewCell

@property (nonatomic, retain) ListItem *item;

+ (CGFloat)heightForItem:(ListItem *)item;

@end
