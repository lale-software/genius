//
//  MyDao.h
//  The Matrix
//
//  Created by Metehan Karabiber on 2/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Alghorithm.h"

@interface MyDao : NSObject 

+ (NSString *) pathToDb:(BOOL)isUser;

+ (NSArray *) getAlghorithmInPhase:(int) phase;

+ (void) insertScore:(int)score withLevel:(int)level;
+ (NSArray *) getLocalHiScores;

+ (void) saveHiScores;
+ (void) loadHiScores;
+ (void) saveFinishedModes;
+ (void) loadFinishedModes;
+ (void) saveNickname;
+ (void) loadNickname;


@end
