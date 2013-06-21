//
//  BaseViewController.m
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "BaseViewController.h"

#import "BaseView.h"

#pragma mark - BaseViewController extension -

@interface BaseViewController()

@property (nonatomic, retain) BaseView *view;

@end

#pragma mark - BaseViewController implementation

@implementation BaseViewController

#pragma mark - Constructor/Destructor methods -

#pragma mark - View life cycle methods -

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view viewDidDisappear:animated];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

@end
