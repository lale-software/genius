//
//  Alghorithm.m
//  The Matrix
//
//  Created by Metehan Karabiber on 2/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Alghorithm.h"


@implementation Alghorithm

- (void) addNewAlgLine:(AlgLine *) algLine {
	
	if (self.algLines == nil) {
		self.algLines = [[NSMutableArray alloc] init];
	}
	
	[self.algLines addObject:algLine];
}

@end
