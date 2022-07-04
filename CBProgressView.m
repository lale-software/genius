//
//  CBProgressView.m
//  TCCB_iPad
//
//  Created by Metehan Karabiber on 2/13/12.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

#import "CBProgressView.h"
#import <QuartzCore/QuartzCore.h>
#import "NSString+LS.h"

@implementation CBProgressView
@synthesize progressLbl;

- (id) initWithLabel:(NSString *)text {
    CGFloat width = [NSString getWidthWithText:text withFont:[UIFont boldSystemFontOfSize:16]];

	if (text == nil)
		width -= 16;

    self = [super initWithFrame:CGRectMake(0, 0, width+64, 48)];
    self.backgroundColor = [UIColor blackColor];
    self.alpha = 0.75f;
    self.layer.cornerRadius = 8;
    self.clipsToBounds = YES;

    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [aiv startAnimating];
    aiv.center = CGPointMake(24, 24);
    [self addSubview:aiv];

    progressLbl = [[UILabel alloc] initWithFrame:CGRectMake(44, 12, width, 24)];
    progressLbl.text = text;
    progressLbl.textColor = [UIColor whiteColor];
    progressLbl.backgroundColor = [UIColor clearColor];
    progressLbl.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:progressLbl];

    return self;
}

@end
