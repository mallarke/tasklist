//
//  Container.m
//  libgp
//
//  Created by mallarke on 3/16/13.
//  Copyright (c) 2013 givepulse, inc. All rights reserved.
//

#import "Container.h"

#define CORNER_RADIUS CONTAINER_CORNER_RADIUS + CONTAINER_BORDER_WIDTH

#define GRADIENT_DARK_VALUE 0.23
#define GRADIENT_MID_VALUE 0.5
#define GRADIENT_LIGHT_VALUE 0.8
#define GRADIENT_SCALE_FACTOR 0.3

static const CGFloat kSelectionOverlayHeight = 40;
static const CGFloat kSelectionOverlayAlpha = 0.8;

#define OVERLAY_GRADIENT_VERY_DARK_COLOR COLOR(9, 36, 60)
#define OVERLAY_GRADIENT_DARK_COLOR COLOR(62, 118, 169)
#define OVERLAY_GRADIENT_LIGHT_COLOR COLOR(134, 186, 233)

#pragma mark - GradientView extension -

@interface GradientView()

@property (readwrite) CGGradientRef defaultGradient;

- (UIBezierPath *)makePath:(CGRect)rect radius:(CGFloat)radius;

- (UIBezierPath *)makeSinglePath:(CGRect)rect radius:(CGFloat)radius;
- (UIBezierPath *)makeTopPath:(CGRect)rect radius:(CGFloat)radius;
- (UIBezierPath *)makeMiddlePath:(CGRect)rect radius:(CGFloat)radius;
- (UIBezierPath *)makeBottomPath:(CGRect)rect radius:(CGFloat)radius;

@end

#pragma mark - GradientView implementation -

@implementation GradientView

@synthesize type = type_;
@synthesize defaultGradient = defaultGradient_;

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];
    
    if(self)
	{
        self.backgroundColor = [UIColor clearColor];
        
        CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
        
        CGFloat locations[] =
        {
            0.0, 1.0
        };
        
        CGFloat colors[] =
        {
            CONTAINER_START_GRADIENT_COLOR_VALUE, CONTAINER_START_GRADIENT_COLOR_VALUE, CONTAINER_START_GRADIENT_COLOR_VALUE, 1.0,
            CONTAINER_END_GRADIENT_COLOR_VALUE, CONTAINER_END_GRADIENT_COLOR_VALUE, CONTAINER_END_GRADIENT_COLOR_VALUE, 1.0
        };
        
        self.defaultGradient = CGGradientCreateWithColorComponents(colorspace, colors, locations, 2);
        CGColorSpaceRelease(colorspace);
    }
    
    return self;
}

- (void)dealloc
{
    CGGradientRelease(self.defaultGradient);
    
	[super dealloc];
}

#pragma mark - Private methods -

- (UIBezierPath *)makePath:(CGRect)rect radius:(CGFloat)radius
{
    switch(self.type)
    {
        case ContainerType_SINGLE:
            return [self makeSinglePath:rect radius:radius];
            
        case ContainerType_TOP:
            return [self makeTopPath:rect radius:radius];
            
        case ContainerType_MIDDLE:
            return [self makeMiddlePath:rect radius:radius];
            
        case ContainerType_BOTTOM:
            return [self makeBottomPath:rect radius:radius];
    }
}

- (UIBezierPath *)makeSinglePath:(CGRect)rect radius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
}

- (UIBezierPath *)makeTopPath:(CGRect)rect radius:(CGFloat)radius
{
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGPoint startPoint = CGPointZero;
    startPoint.x = x;
    startPoint.y = y + height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:CGPointMake(x, y + radius)];
    
    CGPoint center = CGPointZero;
    center.x = x + radius;
    center.y = y + radius;
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:-90 clockwise:true];
    
    [path addLineToPoint:CGPointMake((x + width) - radius, y)];
    
    center.x = (x + width) - radius;
    center.y = y + radius;
    [path addArcWithCenter:center radius:radius startAngle:90 endAngle:0 clockwise:true];
    
    [path addLineToPoint:CGPointMake(x + width, y + height)];
    [path closePath];
    
    return path;
}

- (UIBezierPath *)makeMiddlePath:(CGRect)rect radius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithRect:rect];
}

- (UIBezierPath *)makeBottomPath:(CGRect)rect radius:(CGFloat)radius
{
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGPoint startPoint = CGPointZero;
    startPoint.x = x;
    startPoint.y = y;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:CGPointMake(x + width, y)];
    [path addLineToPoint:CGPointMake(x + width, (y + height) - radius)];
    
    CGPoint center = CGPointZero;
    center.x = (x + width) - radius;
    center.y = (y + height) - radius;
    [path addArcWithCenter:center radius:radius startAngle:-90 endAngle:0 clockwise:true];
    [path addLineToPoint:CGPointMake((x + width) - radius, y + height)];
    [path addLineToPoint:CGPointMake(x + radius, y + height)];
    
    center.x = x + radius;
    center.y = (y + height) - radius;
    [path addArcWithCenter:center radius:radius startAngle:0 endAngle:-90 clockwise:true];
    [path addLineToPoint:CGPointMake(x, (y + height) - radius)];
    
    [path closePath];
    
    return path;
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
        CGContextSetFillColorWithColor(context, self.strokeColor.CGColor);
        [self.strokePath fill];
    }
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    {
        UIBezierPath *path = self.fillPath;
        if(path)
        {
            CGContextAddPath(context, path.CGPath);
            CGContextClip(context);
            
            CGPoint endPoint = CGPointMake(0, self.bounds.size.height);
            CGContextDrawLinearGradient(context, self.currentGradient, CGPointZero, endPoint, 0);
        }
    }
    CGContextRestoreGState(context);
}

#pragma mark - Protected methods -

#pragma mark - Getter/Setter methods -

- (void)setType:(ContainerType)type
{
    type_ = type;
    [self setNeedsDisplay];
}

- (CGGradientRef)currentGradient
{
    return self.defaultGradient;
}

- (UIBezierPath *)strokePath
{
    return [self makePath:self.bounds radius:CONTAINER_CORNER_RADIUS];
}

- (UIBezierPath *)fillPath
{
    CGRect rect = self.bounds;
    CGFloat height = (self.useDivider ? DIVIDER_HEIGHT : 0);
    
    switch(self.type)
    {
        case ContainerType_SINGLE:
        case ContainerType_TOP:
            rect.origin.x = rect.origin.y = height;
            rect.size.width -= height * 2;
            rect.size.height -= height * 2;
            break;
            
        case ContainerType_MIDDLE:
            rect.origin.x = height;
            rect.size.width -= height * 2;
            rect.size.height -= height;
            break;
            
        case ContainerType_BOTTOM:
            rect.origin.x = height;
            rect.size.width -= height * 2;
            rect.size.height -= height;
            break;
            
        default:
            return nil;
    }
    
    CGFloat radius = CONTAINER_CORNER_RADIUS - height;
    return [self makePath:rect radius:radius];
}

- (UIColor *)strokeColor
{
    return STROKE_COLOR;
}

- (BOOL)useDivider
{
    return true;
}

@end

#pragma mark - Container extension -

@interface Container()

@property (retain) GradientView *gradient;
@property (readonly) GradientView *customGradient;

@property (readonly) CGRect pathFrame;

@end

#pragma mark - Container implementation

@implementation Container

#pragma mark - Constructor/Destructor methods -

- (id)init
{
    self = [super init];

    if(self) 
	{
        self.backgroundColor = CLEAR_COLOR;
        
        GradientView *gradient = self.customGradient;
        if(gradient)
        {
            self.gradient = gradient;
        }
        else
        {
            self.gradient = [GradientView object];
        }
        
        [self addSubview:self.gradient];
    }

    return self;
}

- (void)dealloc
{
    self.gradient = nil;
    
	[super dealloc];
}

#pragma mark - Public methods -

- (void)addContent:(UIView *)content
{
    [self.gradient addSubview:content];
}

#pragma mark - Private methods -

#pragma mark - Protected methods -

- (void)layoutContent:(CGRect)bounds {}

- (void)layoutSubviews
{
	[super layoutSubviews];

    CGRect frame = self.pathFrame;
    CGSize maxSize = frame.size;

    frame.size.width -= CONTAINER_BORDER_WIDTH * 2;
    frame.size.height -= CONTAINER_BORDER_WIDTH * 2;
    frame.origin.x += (maxSize.width - frame.size.width) / 2.0;
    frame.origin.y += (maxSize.height - frame.size.height) / 2.0;
    self.gradient.frame = frame;

    [self layoutContent:self.gradient.bounds];

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, CONTAINER_BORDER_COLOR.CGColor);

    CGContextSaveGState(context);
    {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.pathFrame cornerRadius:CORNER_RADIUS];
        [path fill];
    }
    CGContextRestoreGState(context);    
}

#pragma mark - Getter/Setter methods -

- (CGRect)contentBounds
{
    // force layout
    [self layoutSubviews];
    
    return self.gradient.bounds;
}

- (CGRect)pathFrame
{
    return self.bounds;
}

@end
