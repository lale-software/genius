//
//  MyRorButton.h
//  The Matrix
//
//  Created by Metehan Karabiber on 12/13/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "MyButton.h"
#import "MyTxButton.h"

@interface MyRorButton : MyButton

@property (nonatomic, strong) MyTxButton *dependingBtn;

@end
