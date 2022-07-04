//
//  ScoreboardVC.m
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

#import "ScoreboardVC.h"
#import "Constants.h"
#import "MyDao.h"
#import "Score.h"

@interface ScoreboardVC()

@property (nonatomic, strong) CBProgressView *progressView;

@property (nonatomic, strong) NSMutableArray *ranks, *usrs, *dates, *points;
@property (nonatomic, strong) NSArray *resultArray;

@property (nonatomic, strong) NSMutableData *strReceivedData;
@property (nonatomic, strong) NSURLConnection *strConnection;

- (void) sendHiScore;
- (void) downloadScores;
- (void) fillScoreboard:(NSString *)result;

- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message;

- (void) showProgressIndicator:(NSString *)label;
- (void) hideProgressIndicator;
@end

@implementation ScoreboardVC

- (void) viewDidLoad {
   [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
	self.tv.backgroundView = nil;
	self.tv.backgroundColor = [UIColor clearColor];

	[self sendHiScore];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) done:(id) sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) sendHiScore {
	int hiScore = [Utils intForKey:HIGHSCORE];
	int lsHiScore = [Utils intForKey:LAST_SUB_HISCORE];
	
	if (hiScore > lsHiScore) {
		[self showProgressIndicator:@"Sending HiScore..."];
		
		NSDate *hsDate = (NSDate *) [Utils objectForKey:HIGHSCORE_DATE];
		NSString *strDate = [[hsDate description] substringToIndex:10];

		NSString *strParams = [NSString stringWithFormat:@"uid=%@&hs=%d&hsDate=%@", [Utils getUUID], hiScore, strDate];
		
		NSURL *strURL = [NSURL URLWithString:@"http://www.lale-software.com/___igenius/hiscore.php"];
		NSMutableURLRequest *strRequest = [NSMutableURLRequest requestWithURL:strURL];
		NSData *strData = [strParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
		[strRequest setHTTPMethod:@"POST"];
		[strRequest setHTTPBody:strData];
		[strRequest setValue:[NSString stringWithFormat:@"%d", [strData length]] forHTTPHeaderField:@"Content-Length"];
		[strRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
		
		self.strConnection = [[NSURLConnection alloc] initWithRequest:strRequest delegate:self];
		
		if (self.strConnection) {
			self.strReceivedData = [NSMutableData data];
		}
		else {
			[self hideProgressIndicator];
			[self showAlertWithTitle:@"CONNECTION FAILED" message:@"We apologize for this, but our database happened to be down at the moment. Please try again later."];
		}
	}
	else {
		[self downloadScores];
	}
}

- (void) downloadScores {
	[self showProgressIndicator:@"Downloading HiScores..."];
	NSString *strParams = [NSString stringWithFormat:@"nick=%@", [Utils strForKey:NICKNAME]];
	
	NSURL *strURL = [NSURL URLWithString:@"http://www.lale-software.com/___igenius/scoreboard.php"];
	NSMutableURLRequest *strRequest = [NSMutableURLRequest requestWithURL:strURL];
	NSData *strData = [strParams dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	[strRequest setHTTPMethod:@"POST"];
	[strRequest setHTTPBody:strData];
	[strRequest setValue:[NSString stringWithFormat:@"%d", [strData length]] forHTTPHeaderField:@"Content-Length"];
	[strRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

	self.strConnection = [[NSURLConnection alloc] initWithRequest:strRequest delegate:self];
	
	if (self.strConnection) {
		self.strReceivedData = [NSMutableData data];
	}
	else {
		[self hideProgressIndicator];
		[self showAlertWithTitle:@"CONNECTION FAILED" message:@"We apologize for this, but our database happened to be down at the moment. Please try again later."];
	}
}

#pragma mark - UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 30;
}

#pragma mark - UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 50;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	UILabel *lbl1, *lbl2, *lbl3, *lbl4;
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		cell.contentView.backgroundColor = [UIColor clearColor];
		cell.backgroundColor = [UIColor clearColor];
		cell.backgroundView = nil;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		
		lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
		lbl1.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:13];
		lbl1.textColor = [UIColor colorWithRed:240 green:240 blue:240 alpha:0.9];
		lbl1.tag = 1001;
		lbl1.backgroundColor = [UIColor clearColor];
		lbl1.textAlignment = NSTextAlignmentCenter;
		[cell.contentView addSubview:lbl1];
		
		lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 120, 30)];
		lbl2.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:13];
		lbl2.textColor = [UIColor colorWithRed:240 green:240 blue:240 alpha:0.9];
		lbl2.tag = 1002;
		lbl2.backgroundColor = [UIColor clearColor];
		lbl2.textAlignment = NSTextAlignmentLeft;
		[cell.contentView addSubview:lbl2];

		lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 70, 30)];
		lbl3.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:13];
		lbl3.textColor = [UIColor colorWithRed:240 green:240 blue:240 alpha:0.9];
		lbl3.tag = 1003;
		lbl3.backgroundColor = [UIColor clearColor];
		lbl3.textAlignment = NSTextAlignmentCenter;
		[cell.contentView addSubview:lbl3];
		
		lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(240, 0, 70, 30)];
		lbl4.font = [UIFont fontWithName:@"AvenirNextCondensed-DemiBold" size:13];
		lbl4.textColor = [UIColor colorWithRed:240 green:240 blue:240 alpha:0.9];
		lbl4.tag = 1004;
		lbl4.backgroundColor = [UIColor clearColor];
		lbl4.textAlignment = NSTextAlignmentRight;
		[cell.contentView addSubview:lbl4];
	}
	else {
		lbl1 = (UILabel *)[cell.contentView viewWithTag:1001];
		lbl2 = (UILabel *)[cell.contentView viewWithTag:1002];
		lbl3 = (UILabel *)[cell.contentView viewWithTag:1003];
		lbl4 = (UILabel *)[cell.contentView viewWithTag:1004];
	}

	NSString *row = self.resultArray[indexPath.row+2];
	NSArray *rowData = [row componentsSeparatedByString:@"|"];
	
	if (row != nil) {
		lbl1.text = [NSString stringWithFormat:@"%d", indexPath.row+1];
		lbl2.text = rowData[0];

		NSMutableString *dateStr = [[NSMutableString alloc] initWithString:rowData[1]];
		[dateStr replaceOccurrencesOfString:@"/" withString:@"." options:1 range:NSMakeRange(0, 8)];
		lbl3.text = dateStr;
		
		NSNumberFormatter *formatter = [NSNumberFormatter new];
		formatter.groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
		formatter.groupingSize = 3;
		formatter.numberStyle = NSNumberFormatterDecimalStyle;
		
		lbl4.text = [formatter stringFromNumber:[NSNumber numberWithInt:[rowData[2] intValue]]];
	}
	
	return cell;
}

- (void) fillScoreboard:(NSString *)result {

	NSArray *array = [result componentsSeparatedByString:@"#"];
	NSString *usrData = array[1];
	NSArray *usrArray = [usrData componentsSeparatedByString:@"|"];

	self.rank.text = usrArray[0];
	self.usr.text = usrArray[1];
	self.date.text = usrArray[2];
	self.point.text = usrArray[3];
	
	self.resultArray = [[NSArray alloc] initWithArray:array];
	[self.tv reloadData];
}

- (void)connectionDidFinishLoading: (NSURLConnection *)connection {
	[self hideProgressIndicator];

	NSString *result = [[NSString alloc] initWithData:self.strReceivedData encoding:NSUTF8StringEncoding];

	if ([result isEqualToString:@"ConnectionFailed"]) {
		[self showAlertWithTitle:@"CONNECTION FAILED" message:@"We apologize for this, but our database happened to be down at the moment. Please try again later."];
	}
	else if ([result hasPrefix:@"SHS"]) {
		if ([result hasPrefix:@"SHS_Success"]) {
			int hs = [[result componentsSeparatedByString:@"|"][1] intValue];

			[Utils saveInt:hs forKey:LAST_SUB_HISCORE];
			[self downloadScores];
		}
		else {
			[self showAlertWithTitle:@"CONNECTION FAILED" message:@"We couldn't get the list from our servers at this time. Please try again later."];
		}
	}
	else if ([result hasPrefix:@"SCR"]) {
		if ([result hasPrefix:@"SCR_Success"]) {
			[self fillScoreboard:result];
		}
		else {
			[self showAlertWithTitle:@"CONNECTION FAILED" message:@"We couldn't get the list from our servers at this time. Please try again later."];
		}
	}
	else {
		[self showAlertWithTitle:@"CONNECTION FAILED" message:@"We couldn't process this request at this time. Please try again later."];
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

- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
																	message:message 
																  delegate:self 
													  cancelButtonTitle:@"OKAY" 
													  otherButtonTitles:nil];
	[alert setBackgroundColor:[UIColor clearColor]];
	[alert show];
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
