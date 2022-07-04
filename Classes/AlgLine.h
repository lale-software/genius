//
//  AlgLine.h
//  The Matrix
//
//  Created by Metehan Karabiber on 2/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface AlgLine : NSObject

@property (readwrite, assign) int algId;
@property (readwrite, assign) int txLine;
@property (nonatomic, strong) NSString *fn;
@property (readwrite, assign) int fnIndex;
@property (readwrite, assign) int op;
@property (nonatomic, strong) NSString *sn;
@property (readwrite, assign) int snIndex;

@end
