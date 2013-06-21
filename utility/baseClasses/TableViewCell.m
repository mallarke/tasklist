//
//  TableViewCell.m
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "TableViewCell.h"

#pragma mark - TableViewCell extension -

@interface TableViewCell()

@property (retain) UIView *divider;

@end

#pragma mark - TableViewCell implementation

@implementation TableViewCell

#pragma mark - Constructor/Destructor methods -

- (id)initTableViewCell:(NSString *)reuseID
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    
    if(self)
    {
        self.divider = [UIView object];
        self.divider.backgroundColor = DIVIDER_COLOR;
        [self addSubview:self.divider];
    }
    
    return self;
}

+ (id)tableViewCell:(NSString *)reuseID
{
    return [[[self alloc] initTableViewCell:reuseID] autorelease];
}

- (void)dealloc
{
    self.divider = nil;
    
    [super dealloc];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGSize maxSize = bounds.size;
    
    CGRect frame = bounds;
    frame.size.width *= self.dividerScale;
    frame.size.height = DIVIDER_HEIGHT;
    frame.origin.x = (maxSize.width - frame.size.width) / 2.0;
    frame.origin.y = maxSize.height - DIVIDER_HEIGHT;
    self.divider.frame = frame;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    [self setSelected:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.divider.backgroundColor = DIVIDER_COLOR;
}

#pragma mark - Getter/Setter methods -

- (CGFloat)dividerScale
{
    return 1;
}

@end

