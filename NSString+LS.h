//
//  NSString(LS).h
//  LSUtils
//
//  Created by Metehan Karabiber on 4/21/11.
//  Copyright 2011 Lale Software. All rights reserved.
//

@interface NSString (LS)

+ (CGFloat) getWidthWithText:(NSString *)text withFont:(UIFont *)font;
+ (CGFloat) getHeightWithText:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width;
+ (CGFloat) fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size forText:(NSString *)text;
+ (NSString *) stringWithInt:(int)integer;

@end
