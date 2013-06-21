//
//  GroupCell.m
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "GroupCell.h"

#pragma mark - GroupCell extension -

@interface GroupCell() 

@property (retain) UILabel *titleLabel;
@property (retain) UIView *itemView;

@end

#pragma mark - GroupCell implementation

@implementation GroupCell

#pragma mark - Constructor/Destructor methods -

- (id)initTableViewCell:(NSString *)reuseID
{
    self = [super initTableViewCell:reuseID];

    if(self) 
	{
        self.titleLabel = make_label(GROUP_CELL_TITLE_FONT);
        [self addSubview:self.titleLabel];
        
        self.itemView = [UIView object];
        [self addSubview:self.itemView];
    }

    return self;
}

- (void)dealloc
{
    self.group = nil;
    
    self.titleLabel = nil;
    self.itemView = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

+ (CGFloat)heightForGroup:(Group *)group
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - (CELL_PADDING * 2);
    CGFloat height = [@"ohai" sizeWithFont:GROUP_CELL_TITLE_FONT constrainedToSize:CGSizeMake(width, 99) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    for(ListItem *item in group.items)
    {
        height += [@"ohai" sizeWithFont:GROUP_CELL_ITEM_FONT constrainedToSize:CGSizeMake(width, 99) lineBreakMode:NSLineBreakByWordWrapping].height;;
    }
    
    height += CELL_PADDING * 2;
    
    return height;
}

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;
	CGSize maxSize = bounds.size;
    
    CGRect frame = CGRectZero;
    frame.origin.x = CELL_PADDING;
    frame.size.width = maxSize.width - (CELL_PADDING * 2);
    frame.size.height = GROUP_CELL_ITEM_HEIGHT;
    self.titleLabel.frame = frame;
    
    frame.origin.y = frame.size.height;
    frame.size.height = (GROUP_CELL_ITEM_HEIGHT * self.group.items.count) + GROUP_CELL_ITEM_HEIGHT;
    self.itemView.frame = frame;
    
    CGFloat width = frame.size.width;
    CGFloat y = 0;
    
    for(UILabel *label in self.itemView.subviews)
    {
        [label sizeToFit];
        label.y = y;
        label.width = width;
        
        y += label.height;
    }
}

#pragma mark - Getter/Setter methods -

- (CGFloat)dividerScale
{
    return 0.85;
}

- (void)setGroup:(Group *)group
{
    [[_group retain] autorelease];
    _group = [group retain];
    
    if(group)
    {
        self.titleLabel.text = group.title;
        
        for(UIView *view in self.itemView.subviews)
        {
            [view removeFromSuperview];
        }
        
        NSArray *sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:false] ];
        NSArray *items = [[group.items allObjects] sortedArrayUsingDescriptors:sortDescriptors];
        
        for(ListItem *item in items)
        {
            UILabel *label = make_label(GROUP_CELL_ITEM_FONT);
            label.text = [NSString stringWithFormat:@"   • %@", item.title];
            [self.itemView addSubview:label];
        }
        
    }
}

@end
