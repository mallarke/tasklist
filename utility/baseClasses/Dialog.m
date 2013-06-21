//
//  Dialog.m
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "Dialog.h"

#import "Container.h"

#pragma mark - DialogOverlay interface -

@protocol DialogOverlayDelegate;

@interface DialogOverlay : UIView

@property (assign) id<DialogOverlayDelegate> delegate;

@property (assign) CGGradientRef gradient;

// private
- (void)onTouch:(UITapGestureRecognizer *)gesture;

@end

@protocol DialogOverlayDelegate <NSObject>

- (void)overlayWasPressed;

@end

#pragma mark - DialogOverlay implementation -

@implementation DialogOverlay

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.backgroundColor = CLEAR_COLOR;
        self.alpha = 0.7;
        
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        
        CGFloat locations[] = { 0, 1 };
        CGFloat colors[] =
        {
            0.25, 0.25, 0.25, 1,
            0, 0, 0, 1
        };
        
        self.gradient = CGGradientCreateWithColorComponents(colorspace, colors, locations, 2);
        CGColorSpaceRelease(colorspace);
        colorspace = nil;
        
        UITapGestureRecognizer *gesture = [UITapGestureRecognizer object];
        [gesture addTarget:self action:@selector(onTouch:)];
        [self addGestureRecognizer:gesture];
    }
    
    return self;
}

- (void)dealloc
{
    CGGradientRelease(self.gradient);
    [super dealloc];
}

#pragma mark - Private methods -

- (void)onTouch:(UITapGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateEnded)
    {
        [self.delegate overlayWasPressed];
    }
}

#pragma mark - Protected methods -

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    {
        CGSize size = self.bounds.size;
        
        CGPoint startCenter = CGPointMake(size.width / 2.0, size.height / 2.0);
        CGPoint endCenter = CGPointMake(size.width / 2.0, size.height / 2.0);
        CGFloat radius = size.width / 2.0;
        
        CGContextDrawRadialGradient(context, self.gradient, startCenter, 0, endCenter, radius, kCGGradientDrawsAfterEndLocation);
    }
    CGContextRestoreGState(context);
}

@end

#pragma mark - Dialog extension -

@interface Dialog() <DialogOverlayDelegate>

@property (retain) DialogOverlay *overlay;
@property (retain) Container *container;

@property (assign) BOOL isAnimating;
@property (readonly) CGFloat containerHeight;

@property (assign) CGPoint initialTouchOnScreen;

- (void)dialogWillAppear;
- (void)dialogDidAppear;

- (void)dialogWillDisappear;
- (void)dialogDidDisappear;

- (void)keyboardWillAppear:(NSNotification *)notification;
- (void)handlePan:(UIPanGestureRecognizer *)gesture;
- (BOOL)shouldDismissKeyboard:(CGPoint)location;

- (void)showInputError;

@end

#pragma mark - Dialog implementation

@implementation Dialog

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.overlay = [DialogOverlay object];
        self.overlay.delegate = self;
        [self addSubview:self.overlay];
        
        self.container = [Container object];
        [self addSubview:self.container];
        
        UIPanGestureRecognizer *gesture = [UIPanGestureRecognizer object];
        [gesture addTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:gesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.overlay = nil;
    self.container = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)show
{
    self.isAnimating = true;
    [self dialogWillAppear];
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *currentView = [window.subviews lastObject];
    [currentView addSubview:self];
    
    self.frame = currentView.bounds;
    self.alpha = 0;
    
    [UIView animateWithDuration:FAST_ANIMATION_SPEED animations:^
     {
         self.alpha = 1;
     }
     completion:^(BOOL finished)
     {
         self.isAnimating = false;
         [self dialogDidAppear];
     }];
}

#pragma mark - Private methods -

- (void)dialogWillAppear {}
- (void)dialogDidAppear {}

- (void)dialogWillDisappear
{
    if([self.delegate respondsToSelector:@selector(dialogWillDismiss:)])
        [self.delegate dialogWillDismiss:self];
}

- (void)dialogDidDisappear
{
    if([self.delegate respondsToSelector:@selector(dialogDidDismiss:)])
        [self.delegate dialogDidDismiss:self];
}

- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    CGRect bounds = self.bounds;

    CGFloat y = 0;
    CGFloat statusBarHeight = 0;
    
    // portrait
    if(keyboardFrame.origin.y > 0)
    {
        statusBarHeight = statusBarSize.height;
        y = keyboardFrame.origin.y;
    }
    else // horizontal
    {
        statusBarHeight = statusBarSize.width;
        y = bounds.size.height - keyboardFrame.size.width;
    }

    y -= statusBarHeight;
    y = ((y - self.container.height) / 2.0) + statusBarHeight;

    [UIView animateWithDuration:duration animations:^
     {
         self.container.y = y;
     }];
}

- (void)handlePan:(UIPanGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    
    switch(gesture.state)
    {
        case UIGestureRecognizerStateBegan:
            self.initialTouchOnScreen = location;
            break;
            
        case UIGestureRecognizerStateEnded:
            if([self shouldDismissKeyboard:location])
            {
                [self overlayWasPressed];
            }
            break;
            
        default:
            break;
    }
}

- (BOOL)shouldDismissKeyboard:(CGPoint)location
{
    CGFloat diff = location.y - self.initialTouchOnScreen.y;
    return (diff > 30);
}

- (void)showInputError
{
    NSString *title = NO_TEXT_ERROR_TITLE;
    NSString *message = NO_TEXT_ERROR_MESSAGE;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

#pragma mark - Protected methods -

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGRect bounds = self.bounds;
    CGSize maxSize = bounds.size;
    
    self.overlay.frame = bounds;
    
    CGRect frame = CGRectZero;
    frame.size.width = maxSize.width - (CELL_PADDING * 2);
    frame.size.height = self.containerHeight;
    self.container.frame = frame;
    [self.container centerView];
}

#pragma mark - Getter/Setter methods -

- (CGFloat)containerHeight
{
    return 0;
}

#pragma mark - DialogOverlayDelegate methods -

- (void)overlayWasPressed
{
    if(self.isAnimating)
    {
        return;
    }
    
    self.isAnimating = true;
    [self dialogWillDisappear];
    
    [UIView animateWithDuration:FAST_ANIMATION_SPEED animations:^
     {
         self.alpha = 0;
     }
     completion:^(BOOL finished)
     {
         self.isAnimating = false;         
         [self dialogDidDisappear];
         
         [self removeFromSuperview];
     }];
}

@end

#pragma mark - CreateDialog extension -

@interface CreateDialog() <UITextFieldDelegate>

@property (retain) UITextField *textField;

@end

#pragma mark - CreateDialog implementation -

@implementation CreateDialog

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];
    
    if(self)
    {
        self.textField = [UITextField object];
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeyDone;
        [self.container addContent:self.textField];
    }
    
    return self;
}

- (void)dealloc
{
    self.textField = nil;
    
    [super dealloc];
}

#pragma mark - Public methods -

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)dialogDidAppear
{
    [super dialogDidAppear];
    
    [self.textField becomeFirstResponder];
}

- (void)dialogWillDisappear
{
    [super dialogWillDisappear];
    
    [self.textField resignFirstResponder];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.container.contentBounds;
    CGSize maxSize = bounds.size;
    
    [self.textField sizeToFit];
    self.textField.width = maxSize.width - CELL_PADDING * 2;
    [self.textField centerView];
}

#pragma mark - Getter/Setter methods -

- (CGFloat)containerHeight
{
    [self.textField sizeToFit];
    return self.textField.height + (CELL_PADDING * 2);
}

- (NSString *)placeholder
{
    return self.textField.placeholder;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    self.textField.placeholder = placeholder;
}

#pragma mark - UITextFieldDelegate methods -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *title = textField.text;
    
    if(title && ![title isEqualToString:@""])
    {
        [self.delegate createDialog:self didEnterName:self.textField.text];
        [self overlayWasPressed];
    }
    else
    {
        [self showInputError];
    }
    
    return true;
}

@end

