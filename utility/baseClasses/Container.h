//
//  Container.h
//  libgp
//
//  Created by mallarke on 3/16/13.
//  Copyright (c) 2013 givepulse, inc. All rights reserved.
//

typedef enum
{
    ContainerType_SINGLE,
    ContainerType_TOP,
    ContainerType_MIDDLE,
    ContainerType_BOTTOM
} ContainerType;

#pragma mark - GradientView interface -

@interface GradientView : UIView

@property (nonatomic, assign) ContainerType type;

@property (readonly) UIBezierPath *strokePath;
@property (readonly) UIBezierPath *fillPath;

@property (readonly) UIColor *strokeColor;

// for inheriting purposes. don't use directly
@property (readonly) CGGradientRef currentGradient;
@property (readonly) CGGradientRef defaultGradient;

@end

#pragma mark - Container interface -

@interface Container : UIView

@property (readonly) CGRect contentBounds;

- (void)addContent:(UIView *)content; // use this instead of addSubview
- (void)layoutContent:(CGRect)bounds; // use this instead of layoutSubviews

@end
