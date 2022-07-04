//
//  SettingsVC.m
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

#import "SettingsVC.h"
#import "Constants.h"

@interface SettingsVC()

@property (nonatomic, strong) CBProgressView *progressView;

@property (nonatomic, strong) NSMutableData *strReceivedData;
@property (nonatomic, strong) NSURLConnection *strConnection;

@property (nonatomic, strong) AVAudioPlayer *setPlayer;

- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message;

- (void) showProgressIndicator:(NSString *)label;
- (void) hideProgressIndicator;
@end

@implementation SettingsVC

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];

	[self.gameMusicChoice setTintColor:[UIColor colorWithRed:0.70 green:0.171 blue:0.1 alpha:1.0]];
	
	BOOL bypass	   = [Utils boolForKey:BYPASS_MODES];
	BOOL menuMusic = [Utils boolForKey:MENU_MUSIC_SET] ? [Utils boolForKey:MENU_MUSIC] : YES;
	BOOL gameSound = [Utils boolForKey:GAME_SOUND_SET] ? [Utils boolForKey:GAME_SOUND] : YES;
	NSString *nick = [Utils strForKey:NICKNAME];

	[self.menuMusicSwitch setOn:menuMusic animated:YES];
	[self.gameSoundSwitch setOn:gameSound animated:YES];
	[self.bypassModesSwitch setOn:bypass animated:YES];
	[self.username setText:nick];
	self.username.font = [UIFont fontWithName:@"Helvetica" size:15];

	if ([Utils strForKey:NICKNAME] != nil) {
		[self.registerBtn setBackgroundImage:[UIImage imageNamed:@"ChangeBtn.png"] forState:UIControlStateNormal];
		[self.registerBtn setBackgroundImage:[UIImage imageNamed:@"ChangeBtnHgh.png"] forState:UIControlStateHighlighted];
	}
}

///////////////////////////////////////////////////////
///////////////////	IBACTIONS  //////////////////////
/////////////////////////////////////////////////////

- (IBAction) registerNickname:(id)sender {
	NSString *nick = [self.username text];

	nick = [nick stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

	if (nick == nil || [nick isEqualToString:@""]) {
		[self.username setText:@""];
		return;
	}

	if ([nick isEqualToString:[Utils strForKey:NICKNAME]]) {
		return;
	}

	NSRange range = [nick rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"#|"]];
	
	if (range.location != NSNotFound) {
		[self showAlertWithTitle:@"ERROR" message:@"Please do not use the characters '#' or '|'."];
		return;
	}

	[self.username resignFirstResponder];
	[self showProgressIndicator:@"Registering..."];

	NSString *strParams = [NSString stringWithFormat:@"uid=%@&nick=%@", [Utils getUUID] ,nick];
	NSString *url = @"http://www.lale-software.com/___igenius/register.php";

	NSMutableURLRequest *strRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	NSData *strData = [strParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	[strRequest setHTTPMethod:@"POST"];
	[strRequest setHTTPBody:strData];
	[strRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[strData length]] forHTTPHeaderField:@"Content-Length"];
	[strRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

	self.strConnection = [[NSURLConnection alloc] initWithRequest:strRequest delegate:self];

	if (self.strConnection) {
		self.strReceivedData = [NSMutableData data];
	}
	else {
		[self hideProgressIndicator];
		[self showAlertWithTitle:@"CONNECTION FAILED" message:@"Connection to server failed at this time. Please try again later."];
	}
}

- (IBAction) menuMusicChanged:(id)sender {
	UISwitch *switchCtl = (UISwitch *) sender;
	
	[Utils saveBool:YES forKey:MENU_MUSIC_SET];
	[Utils saveBool:switchCtl.on forKey:MENU_MUSIC];

	[[NSNotificationCenter defaultCenter] postNotificationName:MUSIC_NOTIF object:self];
	
	if (switchCtl.on) {
		[self.setPlayer stop];
	}
}

- (IBAction) gameMusicChanged:(id)sender {
	
	UISegmentedControl *segCtrl = (UISegmentedControl *) sender;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[defaults setBool:YES forKey:GAME_MUSIC_SET];
	[defaults setInteger:segCtrl.selectedSegmentIndex forKey:GAME_MUSIC];
	[defaults synchronize];

	if (segCtrl.selectedSegmentIndex == 0) {
		@try { [self.setPlayer stop];	}
		@catch (NSException *e) {
			@try { [self.setPlayer stop];	}
			@catch (NSException *e) { }		
		}

		if ([defaults boolForKey:@"MENU_MUSIC_FLAG"]) {
			[defaults setBool:YES forKey:MENU_MUSIC];
			[defaults setBool:NO forKey:@"MENU_MUSIC_FLAG"];
			[defaults synchronize];

			[[NSNotificationCenter defaultCenter] postNotificationName:MUSIC_NOTIF object:self];
			[self.menuMusicSwitch setOn:YES animated:YES];
		}
		
		return;
	}

	if ([defaults boolForKey:MENU_MUSIC]) {
		[defaults setBool:NO forKey:MENU_MUSIC];
		[defaults setBool:YES forKey:@"MENU_MUSIC_FLAG"];
		[defaults synchronize];

		[[NSNotificationCenter defaultCenter] postNotificationName:MUSIC_NOTIF object:self];
		[self.menuMusicSwitch setOn:NO animated:YES];
	}
		
	NSString *musicPath;
	
	if      (segCtrl.selectedSegmentIndex == 1)	musicPath = [[NSBundle mainBundle] pathForResource:@"GameMusicTrack3" ofType:@"caf"];
	else if (segCtrl.selectedSegmentIndex == 2) musicPath = [[NSBundle mainBundle] pathForResource:@"GameMusicTrack2" ofType:@"caf"];
	else if (segCtrl.selectedSegmentIndex == 3) musicPath = [[NSBundle mainBundle] pathForResource:@"DemoMusic" ofType:@"caf"];
	
	AVAudioPlayer *tmpMP = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:nil];
	self.setPlayer = tmpMP;
	
	[self.setPlayer setNumberOfLoops:-1];
	[self.setPlayer setVolume:0.8];
	
	@try {
		[self.setPlayer play];
	}
	@catch (NSException *e) {
		@try { [self.setPlayer play]; }
		@catch (NSException *e) {	}
	}
}

- (IBAction) gameSoundChanged:(id)sender {
	UISwitch *switchCtl = (UISwitch *) sender;
	
	[Utils saveBool:YES forKey:GAME_SOUND_SET];
	[Utils saveBool:switchCtl.on forKey:GAME_SOUND];
}

- (IBAction) bypassModesChanged:(id)sender {
	UISwitch *switchCtl = (UISwitch *) sender;

	[Utils saveBool:switchCtl.on forKey:BYPASS_MODES];
}

- (IBAction) dismissSettings:(id)sender {

	@try {
		[self.setPlayer stop];
	}
	@catch (NSException *e) {
		@try { [self.setPlayer stop]; }
		@catch (NSException *e) {	}
	}

	if ([Utils boolForKey:@"MENU_MUSIC_FLAG"]) {
		[Utils saveBool:YES forKey:MENU_MUSIC];
		[Utils saveBool:NO forKey:@"MENU_MUSIC_FLAG"];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:MUSIC_NOTIF object:self];
		[self.menuMusicSwitch setOn:YES animated:YES];
	}

	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	[textField resignFirstResponder];
	return YES;
}

- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message {
	
	[UIView animateWithDuration:0.3
					 animations:^{
						 [self.view setAlpha:0.2];
					 }];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:message
												   delegate:self
										  cancelButtonTitle:@"OKAY"
										  otherButtonTitles:nil];
	[alert setBackgroundColor:[UIColor clearColor]];
	
	[alert show];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[UIView animateWithDuration:1.0
					 animations:^{
						 [self.view setAlpha:1.0];
					 }];
}

////////////////////////////////////////////////////////////
////////////////////		CONNECTION      ////////////////////
////////////////////////////////////////////////////////////

- (void)connectionDidFinishLoading: (NSURLConnection *)connection {

	[self hideProgressIndicator];

	NSString *result = [[NSString alloc] initWithData:self.strReceivedData encoding:NSUTF8StringEncoding];
	NSString *change = [Utils strForKey:NICKNAME];

	if ([result isEqualToString:@"Success"]) {
		[Utils saveObj:self.username.text forKey:NICKNAME];

		if (change == nil) {
			[self showAlertWithTitle:@"SUCCESSFUL" message:@"Your nickname is successfully registered!"];

			[self.registerBtn setBackgroundImage:[UIImage imageNamed:@"ChangeBtn.png"] forState:UIControlStateNormal];
			[self.registerBtn setBackgroundImage:[UIImage imageNamed:@"ChangeBtnHgh.png"] forState:UIControlStateHighlighted];
		}
		else {
			[self showAlertWithTitle:@"SUCCESSFUL" message:@"Your nickname is successfully changed!"];		
		}
	}
	else if ([result isEqualToString:@"ConnectionFailed"]) {
		[self showAlertWithTitle:@"ERROR" message:@"We apologize for this, but our database happened to be down at the moment. Please try again later."];		
	}
	else if ([result isEqualToString:@"NickExists"]) {
		[self showAlertWithTitle:@"ERROR" message:@"The nickname you entered is already used by another user. Please change it and try again."];		
	}
	else {
		[self showAlertWithTitle:@"ERROR" message:@"We couldn't process this request at this time. Please try again later."];		
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[self.strReceivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[self.strReceivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	[self hideProgressIndicator];
	
	[self showAlertWithTitle:@"CONNECTION FAILED" message:@"Connection to server failed at this time. Please try again later."];
}

////////////////////////////   ACTIVITY     ///////////////////
- (void) showProgressIndicator:(NSString *)label {
	self.progressView = [[CBProgressView alloc] initWithLabel:label];
	self.progressView.center = CGPointMake(160, 218);
	self.progressView.alpha = 0.0f;
	[self.view addSubview:self.progressView];
	[self.view bringSubviewToFront:self.progressView];

	[UIView animateWithDuration:0.3 animations:^{ self.progressView.alpha = 1.0f; }];
}

- (void) hideProgressIndicator {
	[UIView animateWithDuration:0.3
					 animations:^ {
						 self.progressView.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 [self.progressView removeFromSuperview];
						 self.progressView = nil;
					 }];
}

@end