//
//  colors.h
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#define COLORV(__value__) (__value__/255.0)
#define COLOR(__r__, __g__, __b__) [UIColor colorWithRed:COLORV(__r__) green:COLORV(__g__) blue:COLORV(__b__) alpha:1.0]

#define GREY(__value__) COLOR(__value__, __value__, __value__)

#define CLEAR_COLOR [UIColor clearColor]
#define WHITE_COLOR [UIColor whiteColor]
#define BLACK_COLOR [UIColor blackColor]
#define PURPLE_COLOR [UIColor purpleColor]
#define ORANGE_COLOR [UIColor orangeColor]
#define DARK_BLUE_COLOR COLOR(21, 70, 129)

#define DIVIDER_COLOR GREY(140)
#define STROKE_COLOR GREY(180)

#define CONTAINER_START_GRADIENT_COLOR_VALUE COLORV(240)
#define CONTAINER_END_GRADIENT_COLOR_VALUE COLORV(200)
#define CONTAINER_BORDER_COLOR GREY(95)