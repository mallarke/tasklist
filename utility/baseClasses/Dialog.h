//
//  Dialog.h
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DialogDelegate;

@interface Dialog : UIView

@property (assign) id<DialogDelegate> delegate;

- (void)show;

@end

@protocol DialogDelegate <NSObject>

@optional

- (void)dialogWillDismiss:(Dialog *)dialog;
- (void)dialogDidDismiss:(Dialog *)dialog;

@end

#pragma mark - CreateDialog interface -

@class CreateDialog;

@protocol CreateDialogDelegate <DialogDelegate>

- (void)createDialog:(CreateDialog *)dialog didEnterName:(NSString *)name;

@end

@interface CreateDialog : Dialog

@property (assign) id<CreateDialogDelegate> delegate;

@property (nonatomic, retain) NSString *placeholder;

@end
