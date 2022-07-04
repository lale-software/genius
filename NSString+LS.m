//
//  NSString(LS).m
//  LSUtils
//
//  Created by Metehan Karabiber on 4/21/11.
//  Copyright 2011 Lale Software. All rights reserved.
//

@implementation NSString (LS)

+ (CGFloat) getWidthWithText:(NSString *)text withFont:(UIFont *)font {
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
	return size.width;
}

+ (CGFloat) getHeightWithText:(NSString *)text withFont:(UIFont *)font withWidth:(CGFloat)width {
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
	return size.height;
}

+ (CGFloat) fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size forText:(NSString *)text {
	CGFloat fontSize = [font pointSize];
	CGFloat height = [text sizeWithFont:font constrainedToSize:CGSizeMake(size.width,FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
	UIFont *newFont = font;

	//Reduce font size while too large, break if no height (empty string)
	while (height > size.height && height != 0) {   
		fontSize--;  
		newFont = [UIFont fontWithName:font.fontName size:fontSize];   
		height = [text sizeWithFont:newFont constrainedToSize:CGSizeMake(size.width,FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping].height;
	};

	// Loop through words in string and resize to fit
	for (NSString *word in [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]) {
		CGFloat width = [word sizeWithFont:newFont].width;
		while (width > size.width && width != 0) {
			fontSize--;
			newFont = [UIFont fontWithName:font.fontName size:fontSize];   
			width = [word sizeWithFont:newFont].width;
		}
	}
	return fontSize;
}

+ (NSString *) stringWithInt:(int)integer {
	return [NSString stringWithFormat:@"%d", integer];
}

@end
