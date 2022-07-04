//
//  AboutVC.m
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

#import "AboutVC.h"
#import "Constants.h"

@implementation AboutVC

- (void) viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
}

- (IBAction) dismissAbout:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) linkClicked:(id)sender {
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Would you like to visit our website?\n"
																				delegate:self 
																	cancelButtonTitle:nil 
															 destructiveButtonTitle:@"No" 
																	otherButtonTitles:@"Yes (Exits Game)", nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
	[actionSheet showInView:self.view];
}

- (IBAction) otherAppsClicked:(id)sender {
	self.oavc = [[OtherAppsVC alloc] initWithNibName:@"OtherApps" bundle:nil];
	[self.navigationController pushViewController:self.oavc animated:YES];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
		
	if (buttonIndex == actionSheet.firstOtherButtonIndex) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://en.lale-software.com"]];
	}
}

@end
