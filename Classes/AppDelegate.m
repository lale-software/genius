//
//  AppDelegate.m
//
//  Created by Metehan Karabiber on 11/20/08.
//  Copyright Lale Software 2009. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import "MyDao.h"
#import "Constants.h"

@interface AppDelegate (Private)
- (void) createEditableCopyOfDatabaseIfNeeded;
- (void) loadUserSpecificData;
@end

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

	[self createEditableCopyOfDatabaseIfNeeded];
	[self loadUserSpecificData];

	MainVC *mainVC = [[MainVC alloc] initWithNibName:@"MainView" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainVC];
	navController.navigationBarHidden = YES;
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window.rootViewController = navController;
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[MyDao saveHiScores];
	[MyDao saveFinishedModes];
	[MyDao saveNickname];
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (void) createEditableCopyOfDatabaseIfNeeded {
	// First, test for existence.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"genius_user.sqlite"];
	BOOL success = [fileManager fileExistsAtPath:writableDBPath];
	if (success) 
		return;

	// The writable database does not exist, so copy the default to the appropriate location.
	NSError *error;
	NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"genius_user.sqlite"];
	success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if (!success) {
		NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (void) loadUserSpecificData {
	[MyDao loadHiScores];
	[MyDao loadFinishedModes];
	[MyDao loadNickname];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	[Utils saveBool:YES forKey:INTERRUPTED];

	[[NSNotificationCenter defaultCenter] postNotificationName:INTER_NOTIF object:self];

	[MyDao saveHiScores];
	[MyDao saveFinishedModes];
	[MyDao saveNickname];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[NSNotificationCenter defaultCenter] postNotificationName:INTER_NOTIF object:self];	
}

@end