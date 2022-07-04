//
//  Generator.h
//  iLuvMath
//
//  Created by Metehan Karabiber on 9/30/08.
//  Copyright 2008 metehan.com. All rights reserved.
//

#import "Row.h"

@interface Generator : NSObject

+ (NSArray *) generateGameInPhase:(int) phase;

+ (NSArray *) generateRandomNumbers:(int) counter;

+ (NSArray *) processAlghorithmWith:(NSArray *) rndNums inPhase:(int) phase;

+ (int) calculateRow:(Row *) row;

+ (BOOL) checkEasyGame:(NSArray *) input;
	
@end
