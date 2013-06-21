//
//  fonts.h
//  flashcards
//
//  Created by mallarke on 6/17/13.
//  Copyright (c) 2013 shadow coding. All rights reserved.
//

#define DEFAULT_FONT_NAME @"HelveticaNeue"
#define BOLD_FONT_NAME @"HelveticaNeue"
#define HEAVY_BOLD_FONT_NAME @"HelveticaNeue-CondensedBold"
#define ITALIC_FONT_NAME @"HelveticaNeue-Italic"

#define kDefaultFont(__size__) [UIFont fontWithName:DEFAULT_FONT_NAME size:__size__]
#define kBoldFont(__size__) [UIFont fontWithName:BOLD_FONT_NAME size:__size__]
#define kCondensedBoldFont(__size__) [UIFont fontWithName:HEAVY_BOLD_FONT_NAME size:__size__]
#define kItalicFont(__size__) [UIFont fontWithName:ITALIC_FONT_NAME size:__size__]

#define GROUP_CELL_TITLE_FONT kCondensedBoldFont(20)
#define GROUP_CELL_ITEM_FONT kDefaultFont(14)

#define ITEM_CELL_TITLE_FONT GROUP_CELL_TITLE_FONT
#define ITEM_CELL_DATE_FONT kItalicFont(14)