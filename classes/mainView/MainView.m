//
//  MainView.m
//  List
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "MainView.h"

#import "GroupCell.h"
#import "Dialog.h"

#pragma mark - MainView extension -

@interface MainView() <UITableViewDataSource, UITableViewDelegate>

@property (retain) NSArray *content;
@property (retain) UITableView *tableView;

@property (retain) NSIndexPath *selectedIndex;

@end

#pragma mark - MainView implementation

@implementation MainView

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
    self.content = nil;
    self.tableView = nil;
    
    self.selectedIndex = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)reloadData
{
    self.content = [DataController sharedData].groups;
    [self.tableView reloadData];
}

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(self.selectedIndex)
    {
        [self.tableView deselectRowAtIndexPath:self.selectedIndex animated:true];
        self.selectedIndex = nil;
    }
}

- (void)handleAdd:(NSString *)title
{
    [[DataController sharedData] createGroup:title];
    [self reloadData];
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;
    self.tableView.frame = bounds;
}

#pragma mark - Getter/Setter methods -

#pragma mark - UITableViewDataSource methods -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"addContentCellID";
    
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [GroupCell tableViewCell:cellID];
    }
    
    cell.group = [self.content objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate methods -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Group *group = [self.content objectAtIndex:indexPath.row];
    return [GroupCell heightForGroup:group];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedIndex = indexPath;
    
    Group *group = [self.content objectAtIndex:indexPath.row];
    [self.delegate mainView:self didSelectGroup:group];
}

@end
