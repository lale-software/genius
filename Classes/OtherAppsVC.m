//
//  OtherAppsVC.m
//  The Matrix
//
//  Created by Metehan Karabiber on 4/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "OtherAppsVC.h"
#import "Constants.h"


@interface OtherAppsVC(Private)
- (NSString *) getAppName:(NSInteger) tag;
- (int) getId:(NSString *) appName;
@end

@implementation OtherAppsVC

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
	if (is_iPhone5()) {
		UIImageView *bv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 538, 320, 30)];
		bv.image = [UIImage imageNamed:@"BarBottom.png"];
		[self.view addSubview:bv];
	}
}

- (NSString *) getAppName:(NSInteger) tag {
	if (tag ==  1) return @"'My Love'? ($0.99)";
	if (tag ==  2) return @"'My Mom'? (FREE)";
	if (tag ==  3) return @"'My Dad'? ($0.99)";
	if (tag ==  4) return @"'My Friend'? ($0.99)";
	if (tag ==  5) return @"'My Daughter'? ($0.99)";
	if (tag ==  6) return @"'My Daughter II'? ($0.99)";
	if (tag ==  7) return @"'My Son'? ($0.99)";
	if (tag ==  8) return @"'My Son II'? ($0.99)";
	if (tag ==  9) return @"'My Sister'? ($0.99)";
	if (tag == 10) return @"'My Sister II'? ($0.99)";
	if (tag == 11) return @"'My Brother'? ($0.99)";
	if (tag == 12) return @"'My Brother II'? ($0.99)";
	if (tag == 13) return @"'Grandma-M'? (FREE)";
	if (tag == 14) return @"'Grandma-F'? (FREE)";
	if (tag == 15) return @"'Grandpa-M'? (FREE)";
	if (tag == 16) return @"'Grandpa-F'? (FREE)";
	
	return nil;
}

- (int) getId:(NSString *) appName {
	
	if ([appName isEqualToString:@"My Love"])			return 296464206;
	if ([appName isEqualToString:@"My Mom"])			return 296594035;
	if ([appName isEqualToString:@"My Dad"])			return 296595427;
	if ([appName isEqualToString:@"My Friend"])			return 296599519;
	if ([appName isEqualToString:@"My Daughter"])		return 297546251;
	if ([appName isEqualToString:@"My Daughter II"])	return 301280891;
	if ([appName isEqualToString:@"My Son"])			return 297554008;
	if ([appName isEqualToString:@"My Son II"])			return 301283184;
	if ([appName isEqualToString:@"My Sister"])			return 297554098;
	if ([appName isEqualToString:@"My Sister II"])		return 301301814;
	if ([appName isEqualToString:@"My Brother"])		return 297554249;
	if ([appName isEqualToString:@"My Brother II"])		return 301302392;
	if ([appName isEqualToString:@"Grandma-M"])			return 301303512;
	if ([appName isEqualToString:@"Grandma-F"])			return 301303755;
	if ([appName isEqualToString:@"Grandpa-M"])			return 301304334;
	if ([appName isEqualToString:@"Grandpa-F"])			return 301304581;
	return nil;
}

- (IBAction) dismissView:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) launchAppStore:(id)sender {
	UIButton *btn = (UIButton *) sender;
	NSString *title = [@"Would you like to download " stringByAppendingString:[self getAppName:btn.tag]];

	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
															 delegate:self
														cancelButtonTitle:nil
											   destructiveButtonTitle:@"No"
													otherButtonTitles:@"Yes (Exits Game)", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.firstOtherButtonIndex) {
		NSArray *strs = [actionSheet.title componentsSeparatedByString:@"'"];
		NSString *appName = strs[1];
		NSString *appUrl = [NSString stringWithFormat:@"https://itunes.apple.com/app/my-love/id%d", [self getId:appName]];

		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
	}
}

@end
