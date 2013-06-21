//
//  Utility.m
//  list
//
//  Created by mallarke on 6/20/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#import "Utility.h"


UILabel *make_label(UIFont *font)
{
    if(!font)
        font = kDefaultFont(14);
    
    UILabel *label = [UILabel object];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    
    return label;
}