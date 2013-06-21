//
//  MainViewController.m
//  List
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"

#import "GroupViewController.h"

#pragma mark - MainViewController extension -

@interface MainViewController() <MainViewDelegate>

@property (nonatomic, retain) MainView *view;

@end

#pragma mark - MainViewController implementation

@implementation MainViewController

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.title = GROUP_TITLE;
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
    self.view = [MainView object];
    self.view.delegate = self;

    self.navigationItem.rightBarButtonItem = self.view.addButton;
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

#pragma mark - MainViewDelegate methods -

- (void)mainView:(MainView *)view didSelectGroup:(Group *)group
{
    GroupViewController *viewController = [GroupViewController object];
    viewController.group = group;
    
    [self.navigationController pushViewController:viewController animated:true];
}

@end
