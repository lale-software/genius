//
//  MyDao.m
//  The Matrix
//
//  Created by Metehan Karabiber on 2/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"
#import "MyDao.h"
#import "sqlite3.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

#import "Score.h"

@implementation MyDao

+ (NSString *) pathToDb:(BOOL)isUser {

	NSString *path;

	if (isUser) {
		NSString *docs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
		path = [docs stringByAppendingPathComponent:@"genius_user.sqlite"];
	}
	else {
		path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"genius.sqlite"];
	}
	
	return path;
}

+ (NSArray *) getAlghorithmInPhase:(int) phase {

	FMDatabase* db = [FMDatabase databaseWithPath:[self pathToDb:NO]];
	
	if (![db open]) {
		NSLog(@"Could not open db.");
		return nil;
	}

	NSMutableArray *ids = [[NSMutableArray alloc] init];
	
	FMResultSet *rs = [db executeQuery:@"SELECT id FROM alghorithms WHERE phase = ?", @(phase)];
	
	while ([rs next]) {
		[ids addObject:@([rs intForColumn:@"id"])];
	}

	srandom(time(NULL));
	int index = random() % [ids count];
	int alg_id = [ids[index] intValue];

	Alghorithm *alg = [[Alghorithm alloc] init] ;

	rs = [db executeQuery:@"SELECT * FROM alg_lines WHERE alg_id = ? ORDER BY tx_line ASC", @(alg_id)];

	while ([rs next]) {
		AlgLine *line = [[AlgLine alloc] init];
		line.txLine = [rs intForColumn:@"tx_line"];
		line.fn = [rs stringForColumn:@"fn"];
		line.fnIndex = [rs intForColumn:@"fn_index"];
		line.op = [rs intForColumn:@"op"];
		line.sn = [rs stringForColumn:@"sn"];
		line.snIndex = [rs intForColumn:@"sn_index"];
		
		[alg addNewAlgLine:line];
	}	
	[rs close];
	[db close];
	
	NSArray *lines = [NSArray arrayWithArray:alg.algLines];
	
	return lines;
}

+ (void) insertScore:(int)score withLevel:(int)level {

	FMDatabase* db = [FMDatabase databaseWithPath:[self pathToDb:YES]];
	if (![db open]) {
		NSLog(@"Could not open db.");
		return;
	}
	
	[db beginTransaction];
	[db executeUpdate:@"INSERT INTO scores (level, score, date) VALUES(?,?, date('now'))", 
							@(level),
							@(score)];	
	[db commit];
	[db close];
}

+ (NSArray *) getLocalHiScores {
	FMDatabase* db = [FMDatabase databaseWithPath:[self pathToDb:YES]];
	if (![db open]) {
		NSLog(@"Could not open db.");
		return nil;
	}	

	FMResultSet *rs = [db executeQuery:@"SELECT * FROM scores ORDER BY score DESC LIMIT 10"];
	NSMutableArray *scores = [[NSMutableArray alloc] initWithCapacity:10];

	while ([rs next]) {
		Score *sc = [[Score alloc] init];
		sc.level = [rs intForColumn:@"level"];
		sc.score = [rs intForColumn:@"score"];
		sc.date = [rs stringForColumn:@"date"];

		[scores addObject:sc];
	}

	[rs close];
	[db close];

	return ([scores count] > 0) ? scores : nil;
}

+ (void) saveHiScores {
	FMDatabase* db = [FMDatabase databaseWithPath:[self pathToDb:YES]];
	if (![db open]) {
		NSLog(@"Could not open db.");
		return;
	}

	int hiScore = [[NSUserDefaults standardUserDefaults] integerForKey:HIGHSCORE];
	
	[db beginTransaction];
	[db executeUpdate:@"UPDATE user_data SET value = ? WHERE name = ?", 
		[NSString stringWithFormat:@"%d", hiScore],
		HIGHSCORE
	];

	int lastSubmittedHiScore = [[NSUserDefaults standardUserDefaults] integerForKey:LAST_SUB_HISCORE];
	
	if (lastSubmittedHiScore > 0) {
		[db executeUpdate:@"UPDATE user_data SET value = ? WHERE name = ?", 
		 [NSString stringWithFormat:@"%d", lastSubmittedHiScore],
		 LAST_SUB_HISCORE
		 ];
	}
	
	[db commit];
	[db close];
}

+ (void) loadHiScores {
	FMDatabase* db = [FMDatabase databaseWithPath:[self pathToDb:YES]];
	if (![db open]) {
		NSLog(@"Could not open db.");
		return;
	}	
	
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM user_data WHERE name = ?", HIGHSCORE ];
	int hiScore = 0;
	
	if ([rs next]) {
		hiScore = [[rs stringForColumn:@"value"] intValue];
	}
	[rs close];

	FMResultSet *rs2 = [db executeQuery:@"SELECT * FROM user_data WHERE name = ?", LAST_SUB_HISCORE ];
	int lastSubmittedHiScore = 0;
	
	if ([rs2 next]) {
		lastSubmittedHiScore = [[rs2 stringForColumn:@"value"] intValue];
	}
	[rs2 close];
	
	[db close];

	[[NSUserDefaults standardUserDefaults] setInteger:lastSubmittedHiScore forKey:LAST_SUB_HISCORE];
	[[NSUserDefaults standardUserDefaults] setInteger:hiScore forKey:HIGHSCORE];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveFinishedModes {

	FMDatabase* db = [FMDatabase databaseWithPath:[self pathToDb:YES]];
	if (![db open]) {
		NSLog(@"Could not open db.");
		return;
	}

	int easyModeScore = [[NSUserDefaults standardUserDefaults] integerForKey:EASY_MODE];
	int mediumModeScore = [[NSUserDefaults standardUserDefaults] integerForKey:MEDIUM_MODE];
	
	if (easyModeScore > 0) {
		[db beginTransaction];
		[db executeUpdate:@"UPDATE user_data SET value = ? WHERE name = ?", [NSString stringWithFormat:@"%d", easyModeScore], EASY_MODE ];

		if (mediumModeScore > 0)
			[db executeUpdate:@"UPDATE user_data SET value = ? WHERE name = ?", [NSString stringWithFormat:@"%d", mediumModeScore], MEDIUM_MODE ];
		
		[db commit];
		[db close];
	}
}

+ (void) loadFinishedModes {
	FMDatabase* db = [FMDatabase databaseWithPath:[self pathToDb:YES]];
	if (![db open]) {
		NSLog(@"Could not open db.");
		return;
	}	
	
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM user_data WHERE name = ?", EASY_MODE];
	int easyModeScore = 0;
	
	if ([rs next]) {
		easyModeScore = [[rs stringForColumn:@"value"] intValue];
	}
	[rs close];
	
	int mediumModeScore = 0;
	
	if (easyModeScore > 0) {
		FMResultSet *rs2 = [db executeQuery:@"SELECT * FROM user_data WHERE name = ?", MEDIUM_MODE];
		
		if ([rs2 next]) {
			mediumModeScore = [[rs2 stringForColumn:@"value"] intValue];
		}
		[rs2 close];
	}

	[db close];
	
	[[NSUserDefaults standardUserDefaults] setInteger:easyModeScore forKey:EASY_MODE];
	[[NSUserDefaults standardUserDefaults] setInteger:mediumModeScore forKey:MEDIUM_MODE];
	[[NSUserDefaults standardUserDefaults] synchronize];	
}

+ (void) saveNickname {

	NSString *nick = [[NSUserDefaults standardUserDefaults] stringForKey:NICKNAME];
	
	if (nick != nil) {
		FMDatabase* db = [FMDatabase databaseWithPath:[self pathToDb:YES]];
		if (![db open]) {
			NSLog(@"Could not open db.");
			return;
		}

		[db beginTransaction];
		[db executeUpdate:@"UPDATE user_data SET value = ? WHERE name = ?", nick, NICKNAME ];
	
		[db commit];
		[db close];
	}
}

+ (void) loadNickname {

	FMDatabase* db = [FMDatabase databaseWithPath:[self pathToDb:YES]];
	if (![db open]) {
		NSLog(@"Could not open db.");
		return;
	}	
	
	FMResultSet *rs = [db executeQuery:@"SELECT * FROM user_data WHERE name = ?", NICKNAME ];
	NSString *nick = nil;
	
	if ([rs next]) {
		nick = [rs stringForColumn:@"value"];
	}
	
	[rs close];
	[db close];
	
	if (nick != nil && [nick isEqualToString:@""] == NO) {
		[[NSUserDefaults standardUserDefaults] setObject:nick forKey:NICKNAME];
		[[NSUserDefaults standardUserDefaults] synchronize];	
	}
}


@end
