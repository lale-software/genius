//
//  MyButton.m
//  The Matrix
//
//  Created by Metehan Karabiber on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MyButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation MyButton

@synthesize button;
@synthesize isUsed;

- (id) initWithButton:(UIButton *)btn value:(int) val index:(int) ind {
	self = [super init];
	
	if (self) {
		self.button = btn;
		self.button.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
		self.button.titleLabel.layer.shadowOffset = CGSizeMake(2.0, 2.0);
		self.button.titleLabel.layer.shadowRadius = 3.0;
		self.button.titleLabel.layer.shadowOpacity = 0.5;
		self.button.titleLabel.layer.masksToBounds = NO;
		
		index = ind;
		self.isUsed = NO;
		[self setIntValue:val];
	}

	return self;
}

- (void) setIntValue:(int) num {
	self.value = num;

	NSString *title = (num == 0)?@"":[NSString stringWithFormat:@"%d", num];
	[self.button setTitle:title forState:UIControlStateNormal];
}

- (void) setTitleColorFlue:(BOOL) flue {
	[self.button setTitleColor:(flue ? [UIColor blackColor] : [UIColor whiteColor]) forState:UIControlStateNormal];
}

- (void) setBgImage:(UIImage *)img {
	[self.button setBackgroundImage:img forState:UIControlStateNormal];
}

- (BOOL) ifUsed {
	return self.isUsed;
}

- (int) getIntValue {
	return self.value;
}

- (int) getIndex {
	return index;
}

@end
