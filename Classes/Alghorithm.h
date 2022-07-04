//
//  Alghorithm.h
//  The Matrix
//
//  Created by Metehan Karabiber on 2/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AlgLine.h"


@interface Alghorithm : NSObject

@property (readwrite, assign) int algId;
@property (readwrite, assign) int phase;

@property (nonatomic, strong) NSMutableArray *algLines;

- (void) addNewAlgLine:(AlgLine *) algLine;

@end
