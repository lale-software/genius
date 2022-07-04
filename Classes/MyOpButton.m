//
//  MyFCButton.m
//  The Matrix
//
//  Created by Metehan Karabiber on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MyOpButton.h"

@implementation MyOpButton

- (void) setIntValue:(int) num {
	self.value = num;

	if		(num == -1)[self.button setTitle:@""  forState:UIControlStateNormal];
	else if (num == 0) [self.button setTitle:@"+" forState:UIControlStateNormal];
	else if (num == 1) [self.button setTitle:@"-" forState:UIControlStateNormal];
	else if (num == 2) [self.button setTitle:@"x" forState:UIControlStateNormal];
	else if (num == 3) [self.button setTitle:@"/" forState:UIControlStateNormal];
}

@end
