//
//  RootViewController.m
//  The Matrix
//
//  Created by Metehan Karabiber on 11/20/08.
//  Copyright lale-software.com 2008. All rights reserved.
//

#import "AppDelegate.h"
#import "MainVC.h"
#import "Constants.h"

#import "TrainingVC.h"
#import "MatrixVC.h"
#import "ScoreboardVC.h"

#import "AboutVC.h"
#import "ContactVC.h"
#import "InstructionsVC.h"
#import "SettingsVC.h"

@interface MainVC (Private)
- (void) startMusic:(NSNotification *)notif;
@end

@implementation MainVC

- (void) viewDidLoad {
   [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
	
	[self startMusic:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startMusic:) name:MUSIC_NOTIF object:nil]; 
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAboutView:) name:ABOUT_NOTIF object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadInstructionsView:) name:HELP_NOTIF object:nil];

	if ([Utils boolForKey:@"CHEATING_ALERT_SHOWN"] == NO) {

		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PLEASE NOTE" 
														message:@"To prevent cheating, you can only attempt to save a game in the first 10 seconds. If you miss it, try to save it in the next level.\n\n(This was a one-time reminder.)"
													   delegate:self
											  cancelButtonTitle:@"OKAY"
											  otherButtonTitles:nil];
		[alert show];
	}
}

// CATEGORY 1
- (IBAction) loadInstructionsView:(id)sender {
	[Utils saveBool:YES forKey:HELP_DONE];

	InstructionsVC *insVC = [[InstructionsVC alloc] initWithNibName:@"InstructionsView" bundle:nil];
	[self presentViewController:insVC animated:YES completion:NULL];
}

- (IBAction) loadAboutView:(id)sender {
	AboutVC *aboutVC = [[AboutVC alloc] initWithNibName:@"AboutView" bundle:nil];

	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:aboutVC];
	nc.navigationBarHidden = YES;
	[self presentViewController:nc animated:YES completion:NULL];
}

- (IBAction) loadContactView:(id)sender {
	[Utils saveBool:YES forKey:CONTACT];

	ContactVC *conVC = [[ContactVC alloc] initWithNibName:@"ContactView" bundle:nil];
	[self presentViewController:conVC animated:YES completion:NULL];
}

- (IBAction) loadSettingsView:(id)sender {
	SettingsVC *setVC = [[SettingsVC alloc] initWithNibName:@"SettingsView" bundle:nil];
	
	[self presentViewController:setVC animated:YES completion:NULL];
}

// CATEGORY 2
- (IBAction) loadTrainingView:(id)sender {
	[Utils saveBool:YES forKey:DEMO_DONE];

	[self.player stop];

	TrainingVC *trainingVC = [[TrainingVC alloc] initWithNibName:@"TrainingView" bundle:nil];
	[self.navigationController pushViewController:trainingVC animated:YES];
}

- (IBAction) loadMatrixView:(id)sender {

	BOOL demo = [Utils boolForKey:DEMO_DONE];
	BOOL help = [Utils boolForKey:HELP_DONE];

	if (demo && help) {
		[self.player stop];

		MatrixVC *matrixVC = [[MatrixVC alloc] initWithNibName:@"MatrixView" bundle:nil];
		[self.navigationController pushViewController:matrixVC animated:YES];
	}
	else {
		[Utils saveBool:YES forKey:DEMO_DONE];
		[Utils saveBool:YES forKey:HELP_DONE];

		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"We strongly recommend going through Demo and Help sections for you to understand the game.\n\n(This is just a one-time reminder)"
																 delegate:self
														cancelButtonTitle:nil
												   destructiveButtonTitle:@"Okay"
														otherButtonTitles:nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[actionSheet showInView:self.view];
	}
}

- (IBAction) loadScoreboardView:(id)sender {
	NSString *nick = [Utils strForKey:NICKNAME];
	
	if (nick == nil) {
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You must register a nickname in Settings for yourself to see the Scoreboard"
																 delegate:self
														cancelButtonTitle:nil
												   destructiveButtonTitle:@"Okay"
														otherButtonTitles:nil];
		actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
		[actionSheet showInView:self.view];
	}
	else {
		ScoreboardVC *scoreboardVC = [[ScoreboardVC alloc] initWithNibName:@"ScoreboardView" bundle:nil];
		[self.navigationController pushViewController:scoreboardVC animated:YES];
	}
}

- (void) startMusic:(NSNotification *)notif {
	music = [Utils boolForKey:MENU_MUSIC_SET] ? [Utils boolForKey:MENU_MUSIC] : YES;

	if (music == YES && [self.player isPlaying] == NO) {
		if (self.player == nil) {
			NSString *path = [[NSBundle mainBundle] pathForResource:@"MenuMusic" ofType:@"mp3"];
			self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
		}

		[self.player setNumberOfLoops:-1];
		[self.player setVolume:1.0];
		
		@try { [self.player play]; }
		@catch (NSException * e) {
			@try { [self.player play];	}
			@catch (NSException * e) {	}
		}
	}
	else if (music == NO && [self.player isPlaying] == YES) {
		@try { [self.player stop]; }
		@catch (NSException * e) {
			@try { [self.player stop];	}
			@catch (NSException * e) {	}
		}
	}
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if ([[alertView title] isEqualToString:@"PLEASE NOTE"]) {
		[Utils saveBool:YES forKey:@"CHEATING_ALERT_SHOWN"];
	}
}

- (void) setViewAlpha:(CGFloat)alpha duration:(NSTimeInterval) duration {
	[UIView animateWithDuration:duration
					 animations:^{
						 [self.view setAlpha:alpha];
					 }];
}

@end

