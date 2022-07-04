//
//  Score.h
//  The Matrix
//
//  Created by Metehan Karabiber on 4/13/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface Score : NSObject

@property (readwrite, assign) int level;
@property (readwrite, assign) int score;
@property (nonatomic, strong) NSString *date;

@end
