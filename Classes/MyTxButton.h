//
//  MyTxButton.h
//  The Matrix
//
//  Created by Metehan Karabiber on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MyButton.h"
#import "MyRndButton.h"

@interface MyTxButton : MyButton

@property (nonatomic, strong) MyButton *btnHeld;
@property (nonatomic, strong) UIImage *actualBgImage;
@property (readwrite, assign) BOOL isRRButton;
@end
