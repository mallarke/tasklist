//
//  GroupViewController.m
//  list
//
//  Created by mallarke on 6/21/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupView.h"

#pragma mark - GroupViewController extension -

@interface GroupViewController()

@property (nonatomic, retain) GroupView *view;

@end

#pragma mark - GroupViewController implementation

@implementation GroupViewController

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{

    }

    return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark - View life cycle methods -

- (void)loadView
{
    self.view = [GroupView object];
    
    self.navigationItem.rightBarButtonItem = self.view.addButton;
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

- (void)setGroup:(Group *)group
{
    self.view.group = group;
    self.title = group.title;
}



@end
