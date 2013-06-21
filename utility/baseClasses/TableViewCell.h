//
//  TableViewCell.h
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (readonly) CGFloat dividerScale;

- (id)initTableViewCell:(NSString *)reuseID;
+ (id)tableViewCell:(NSString *)reuseID;

@end
