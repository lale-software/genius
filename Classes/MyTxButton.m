//
//  MyTxButton.m
//  The Matrix
//
//  Created by Metehan Karabiber on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MyTxButton.h"

@implementation MyTxButton

- (id) initWithButton:(UIButton *)btn value:(int) val index:(int) ind {
	self = [super initWithButton:btn value:val index:ind];
	self.isRRButton = NO;
	self.actualBgImage = nil;
	return self;
}

@end