//
//  Generator.m
//  iGenius
//
//  Created by Metehan Karabiber on 9/30/08.
//  Copyright 2008 metehan.com. All rights reserved.
//

#import "Generator.h"
#import "Row.h"
#import "MyDao.h"
#import "AlgLine.h"

@implementation Generator

+ (NSArray *) generateGameInPhase:(int) phase {

	BOOL success = NO;
	NSArray *game = nil;
	int counter = 0;
	
	do {
		NSArray *rndNums = [self generateRandomNumbers:counter];
		game = [self processAlghorithmWith:rndNums inPhase:phase];

		if (game != nil && [self checkEasyGame:game])
			success = YES;
		
		counter++;
	}
	while (success == NO);

	return game;
}

+ (NSArray *) generateRandomNumbers:(int) counter {

	srandom(time(NULL) + counter);
	int _rn1 = 1 + random() % 9;
	int _rn2 = 1 + random() % 9;
	int _rn3 = 1 + random() % 9;
	int _rn4 = 1 + random() % 9;
	srandom(time(NULL) + counter + 1);
	int _rn5 = (1 + random() % 4) * 25;
	int _rn6 = (1 + random() % 4) * 25;
	
	NSNumber *rn1 = @(_rn1);
	NSNumber *rn2 = @(_rn2);
	NSNumber *rn3 = @(_rn3);
	NSNumber *rn4 = @(_rn4);
	NSNumber *rn5 = @(_rn5);
	NSNumber *rn6 = @(_rn6);
	
	return @[rn1, rn2, rn3, rn4, rn5, rn6];
}

+ (NSArray *) processAlghorithmWith:(NSArray *) rndNums inPhase:(int) phase {

//	NSLog(@"Random Numbers:");
//	NSLog([rndNums description]);

	NSArray *lines = [MyDao getAlghorithmInPhase:phase];
	srandom(time(NULL));

	NSMutableArray *rn1s = [NSMutableArray arrayWithObjects:@0,@1,@2,@3, nil];
	NSMutableArray *rn2s = [NSMutableArray arrayWithObjects:@4,@5, nil];
	NSMutableArray *rrs = [[NSMutableArray alloc] initWithCapacity:5];
	NSMutableArray *rows = [[NSMutableArray alloc] initWithCapacity:5];
	NSMutableArray *solutions = [[NSMutableArray alloc] initWithCapacity:5];

	for (int i = 0; i < [lines count]; i++) {
		AlgLine *line = lines[i];
		AlgLine *solution =  [[AlgLine alloc] init];
		Row *row = [[Row alloc] init];

		srandom(time(NULL));
		if ([line.fn isEqualToString:@"rn1"]) {
			int tmp = random() % [rn1s count];
			line.fnIndex = [rn1s[tmp] intValue];
			row.fn = [rndNums[line.fnIndex] intValue];
			[rn1s removeObjectAtIndex:tmp];
		}
		else if ([line.fn isEqualToString:@"rn2"]) {
			int tmp = random() % [rn2s count];
			line.fnIndex = [rn2s[tmp] intValue];
			row.fn = [rndNums[line.fnIndex] intValue];
			[rn2s removeObjectAtIndex:tmp];
		}
		else if ([line.fn isEqualToString:@"rr"]) {
			row.fn = [rrs[line.fnIndex] intValue]; 
		}

		row.op = line.op;

		srandom(time(NULL));
		if ([line.sn isEqualToString:@"rn1"]) {
			int tmp = random() % [rn1s count];
			line.snIndex = [rn1s[tmp] intValue];
			row.sn = [rndNums[line.snIndex] intValue];
			[rn1s removeObjectAtIndex:tmp];
		}
		else if ([line.sn isEqualToString:@"rn2"]) {
			int tmp = random() % [rn2s count];
			line.snIndex = [rn2s[tmp] intValue];
			row.sn = [rndNums[line.snIndex] intValue];
			[rn2s removeObjectAtIndex:tmp];
		}
		else if ([line.sn isEqualToString:@"rr"]) {
			row.sn = [rrs[line.snIndex] intValue]; 
		}

		row.rr = [self calculateRow:row];
		[rrs addObject:@(row.rr)];

//		NSLog([NSString stringWithFormat:@"Row data: %d %d %d %d", row.fn, row.op, row.sn, row.rr]);

		if (row.rr != 0) {
			[rows addObject:row];
		}
		else {



			return nil;
		}

		solution.txLine = i + 1;
		solution.fn = line.fn;
		solution.fnIndex = line.fnIndex;
		solution.op = line.op;
		solution.sn = line.sn;
		solution.snIndex = line.snIndex;

		[solutions addObject:solution];
	}

	Row *lastRow = rows[[rows count] - 1];

	if (lastRow.rr < 101 || lastRow.rr > 999) {
		
		return nil;
	}
		
	
	NSArray *returnArray = @[rndNums, @(lastRow.rr), solutions];

	return returnArray;
}

+ (int) calculateRow:(Row *) row {
	if (row.op == 0) {
		return row.fn + row.sn;	
	}

	if (row.op == 2) {
		if (row.fn == 1 || row.sn == 1)
			return 0;
		
		return row.fn * row.sn;	
	}
	
	// Substract
	if (row.op == 1) {
		return (row.fn > row.sn)?(row.fn - row.sn):0;
	}

	// Divide
	if (row.op == 3) {
		if (row.sn > 1 && row.fn >= row.sn && (row.fn % row.sn == 0))
			return row.fn/row.sn;
	}
	
	return 0;
}

+ (BOOL) checkEasyGame:(NSArray *) input {
	NSArray *rndNums = input[0];
	int target = [input[1] intValue];
	BOOL pass = YES;
	
	int rnd5 = [rndNums[4] intValue];
	int rnd6 = [rndNums[5] intValue];
	
	if (target == (rnd5 + rnd6)) {
		return NO;
	}
	
	for (int i = 0; i < 4; i++) {
		int rnd = [rndNums[i] intValue];
		
		if (target == (rnd * rnd5) || target == (rnd * rnd6) || target == (rnd + rnd5) || target == (rnd + rnd6)) {
			pass = NO;
			break;
		}
	}
	
	return pass;
}

@end
