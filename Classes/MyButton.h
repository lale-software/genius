//
//  MyButton.h
//  The Matrix
//
//  Created by Metehan Karabiber on 12/12/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

@interface MyButton : NSObject {
	int index;
}

@property (nonatomic, strong) UIButton *button;
@property (readwrite, assign) BOOL isUsed;
@property (readwrite, assign) int value;

- (id) initWithButton:(UIButton *)btn value:(int) val index:(int) ind;

- (void) setIntValue:(int) num;
- (void) setBgImage:(UIImage *)img;
- (void) setTitleColorFlue:(BOOL) flue;

- (BOOL) ifUsed;
- (int) getIntValue;
- (int) getIndex;

@end
