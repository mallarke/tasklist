//
//  GroupView.m
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "GroupView.h"

#import "ItemCell.h"
#import "Dialog.h"

#pragma mark - GroupView extension -

@interface GroupView() <UITableViewDataSource, UITableViewDelegate>

@property (retain) NSArray *content;
@property (retain) UITableView *tableView;

- (void)reloadData;

@end

#pragma mark - GroupView implementation

@implementation GroupView

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.tableView = [UITableView object];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }

    return self;
}

- (void)dealloc
{
    self.group = nil;
    self.content = nil;
    self.tableView = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

- (void)reloadData
{
    self.content = [[DataController sharedData] listItems:self.group.objectID];
    [self.tableView reloadData];
}

#pragma mark - Protected methods -

- (void)handleAdd:(NSString *)title
{
    [[DataController sharedData] addItem:title toGroup:self.group];
    [self reloadData];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;
    self.tableView.frame = bounds;
}

#pragma mark - Getter/Setter methods -

- (void)setGroup:(Group *)group
{
    [[_group retain] autorelease];
    _group = [group retain];
    
    if(group)
    {
        [self reloadData];
    }
}

#pragma mark - UITableViewDataSource methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"itemCellID";
    
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [ItemCell tableViewCell:cellID];
    }
    
    cell.item = [self.content objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListItem *item = [self.content objectAtIndex:indexPath.row];
    return [ItemCell heightForItem:item];
}

@end
