//
//  CBProgressView.h
//  TCCB_iPad
//
//  Created by Metehan Karabiber on 2/13/12.
//  Copyright (c) 2012 T.C. Cumhurbaşkanlığı. All rights reserved.
//

@interface CBProgressView : UIView

@property (nonatomic, strong) UILabel *progressLbl;

- (id) initWithLabel:(NSString *)text;

@end
