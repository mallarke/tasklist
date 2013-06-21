//
//  BaseView.m
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "BaseView.h"

#import "Dialog.h"

#pragma mark - BaseView extension -

@interface BaseView() <CreateDialogDelegate>

@property (readwrite, retain) UIBarButtonItem *addButton;

- (void)onAdd;

@end

#pragma mark - BaseView implementation

@implementation BaseView

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.layer.contents = (id)BACKGROUND_IMAGE.CGImage;
        
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onAdd)];
        self.addButton = [button autorelease];
    }

    return self;
}

- (void)dealloc
{
    self.addButton = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)viewWillAppear:(BOOL)animated {}
- (void)viewWillDisappear:(BOOL)animated {}

- (void)viewDidAppear:(BOOL)animated {}
- (void)viewDidDisappear:(BOOL)animated {}

- (void)handleAdd:(NSString *)title
{
    NSAssert(false, @"Override method in child classes");
}

#pragma mark - Private methods -

- (void)onAdd
{
    CreateDialog *dialog = [CreateDialog object];
    dialog.delegate = self;
    dialog.placeholder = CREATE_GROUP_HINT;
    [dialog show];
}

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

#pragma mark - CreateDialogDelegate methods -

- (void)createDialog:(CreateDialog *)dialog didEnterName:(NSString *)name
{
    [self handleAdd:name];
}

@end
