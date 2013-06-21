//
//  ItemCell.m
//  list
//
//  Created by mallarke on 6/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "ItemCell.h"

#define DATE_FORMAT @"MMM d, yyyy h:mm a"

#pragma mark - ItemCell extension -

@interface ItemCell()

@property (retain) UILabel *title;
@property (retain) UILabel *date;

+ (NSDateFormatter *)dateFormatter;

@end

#pragma mark - ItemCell implementation

@implementation ItemCell

static NSDateFormatter *_dateFormatter = nil;

#pragma mark - Constructor/Destructor methods -

- (id)initTableViewCell:(NSString *)reuseID
{
    self = [super initTableViewCell:reuseID];

    if(self) 
	{
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.title = make_label(ITEM_CELL_TITLE_FONT);
        self.title.numberOfLines = 0;
        [self addSubview:self.title];
        
        self.date = make_label(ITEM_CELL_DATE_FONT);
        [self addSubview:self.date];
    }

    return self;
}

- (void)dealloc
{
    self.title = nil;
    self.date = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

+ (CGFloat)heightForItem:(ListItem *)item
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    width -= CELL_PADDING * 2;
    
    NSString *date = [[self dateFormatter] stringFromDate:item.creationDate];
    
    CGFloat height = [item.title sizeWithFont:ITEM_CELL_TITLE_FONT constrainedToSize:CGSizeMake(width, 99999) lineBreakMode:NSLineBreakByWordWrapping].height;
    height += [date sizeWithFont:ITEM_CELL_DATE_FONT constrainedToSize:CGSizeMake(width, 99) lineBreakMode:NSLineBreakByWordWrapping].height;
    height += CELL_PADDING * 3;
    
    return height;
}

#pragma mark - Private methods -

+ (NSDateFormatter *)dateFormatter
{
    @synchronized(self.class)
    {
        if(!_dateFormatter)
        {
            _dateFormatter = [NSDateFormatter new];
            _dateFormatter.dateFormat = DATE_FORMAT;
        }
        
        return _dateFormatter;
    }
}

#pragma mark - Protected methods -

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;
	CGSize maxSize = bounds.size;
    
    CGFloat width = maxSize.width - (CELL_PADDING * 2);
    CGFloat height = [self.item.title sizeWithFont:ITEM_CELL_TITLE_FONT constrainedToSize:CGSizeMake(width, 99999) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    CGRect frame = CGRectZero;
    frame.size.width = width;
    frame.size.height = height;
    frame.origin.x = CELL_PADDING;
    frame.origin.y = CELL_PADDING;
    self.title.frame = frame;
    
    [self.date sizeToFit];
    frame = self.date.frame;
    frame.origin.x = CELL_PADDING;
    frame.origin.y = maxSize.height - frame.size.height - CELL_PADDING;
    frame.size.width = width;
    self.date.frame = frame;
}

#pragma mark - Getter/Setter methods -

- (void)setItem:(ListItem *)item
{
    [[_item retain] autorelease];
    _item = [item retain];
    
    if(item)
    {
        self.title.text = item.title;
        self.date.text = [[self.class dateFormatter] stringFromDate:item.creationDate];
        
        [self setNeedsLayout];
    }
}

@end
