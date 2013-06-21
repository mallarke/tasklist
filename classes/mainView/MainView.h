//
//  MainView.h
//  List
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

@protocol MainViewDelegate;

@interface MainView : BaseView 

@property (assign) id<MainViewDelegate> delegate;

- (void)reloadData;

@end

@protocol MainViewDelegate <NSObject>

- (void)mainView:(MainView *)view didSelectGroup:(Group *)group;

@end