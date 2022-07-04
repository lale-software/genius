//
//  Utils.m
//  Genius
//
//  Created by Metehan Karabiber on 6/24/14.
//
//

#import "Utils.h"

@implementation Utils

+ (void) saveObj:(NSObject *)obj forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveBool:(BOOL)boolean  forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setBool:boolean forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) saveInt:(int)integer forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setInteger:(NSInteger)integer forKey:key];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSObject *) objectForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString *) strForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+ (BOOL) boolForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (NSInteger) intForKey:(NSString *)key {
	return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (void) showAlertWithDelegate:(id)delegate title:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:delegate
										  cancelButtonTitle:cancelTitle
										  otherButtonTitles:@"Quit", nil];
	[alert setBackgroundColor:[UIColor clearColor]];
	
	[alert show];
}

+ (NSString *) getUUID {
	static NSString *UUID_Key = @"UUID_Key";
	NSString *uuidString = [Utils strForKey:UUID_Key];

	if (uuidString == nil) {
		uuidString = [[NSUUID UUID] UUIDString];
		[Utils saveObj:uuidString forKey:UUID_Key];
	}

	return uuidString;
}

@end
