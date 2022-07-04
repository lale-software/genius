//
//  ContactVC.m
//  The Matrix
//
//  Created by Metehan Karabiber on 4/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ContactVC.h"
#import "Constants.h"

@interface ContactVC(Private)
- (void) showAlertWithTitle:(NSString *)title message:(NSString *)mes;
@end


@implementation ContactVC

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
	
	[self.txtField1 setClearButtonMode:UITextFieldViewModeWhileEditing];
	[self.txtField2 setClearButtonMode:UITextFieldViewModeWhileEditing];

	if ([Utils strForKey:@"CONTACT_FORM_NAME"] != nil) {
		[self.txtField1 setText:[Utils strForKey:@"CONTACT_FORM_NAME"]];
	}
	if ([Utils strForKey:@"CONTACT_FORM_EMAIL"] != nil) {
		[self.txtField2 setText:[Utils strForKey:@"CONTACT_FORM_EMAIL"]];
	}
}

////////////////////////////////////////////////////////

- (void) textFieldDidBeginEditing:(UITextField *) textField {
	[self.cancelBtn setHidden:NO];
	
	if (textField.tag == 1) {
		self.cancelBtn.center = CGPointMake(250, 100);
	}
	else if (textField.tag == 2) {
		self.cancelBtn.center = CGPointMake(250, 185);
	}
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
	[self.cancelBtn setHidden:YES];
	[textField resignFirstResponder];
}

- (IBAction) cancelClicked:(id) sender {
	[self.txtField1 resignFirstResponder];
	[self.txtField2 resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {

	[textField resignFirstResponder];
	
	if (textField == self.name) {
		[self.email becomeFirstResponder];
	}
	else if (textField == self.email) {
		[self.message becomeFirstResponder];
	}

	return YES;
}

- (void) textViewDidBeginEditing:(UITextView *) textView {

	[self.txtViewDoneBtn setHidden:NO];
	
	[UIView animateWithDuration:0.5 animations:^{
		if (is_iPhone5()) {
			self.message.frame = CGRectMake(0, 47, 320, 304);
		}
		else {
			self.message.frame = CGRectMake(0, 47, 320, 216);
		}
		[self.view bringSubviewToFront:self.message];
	}];
}

- (void) textViewDidEndEditing:(UITextView *)textView {
	[self.txtViewDoneBtn setHidden:YES];

	[UIView animateWithDuration:0.5 animations:^{
		self.message.frame = CGRectMake(20, 238, 240, 130);
	}];
}

- (IBAction) doneClicked:(id) sender {
	[self.message resignFirstResponder];
}

- (IBAction) dismissContact:(id) sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) sendEmail:(id)sender {
	NSString *__name = [self.name text];
	
	if (![__name isEqualToString:@""]) {
		[Utils saveObj:__name forKey:@"CONTACT_FORM_NAME"];
	}
	
	NSString *__email = [self.email text];
	if (![__email isEqualToString:@""]) {
		[Utils saveObj:__email forKey:@"CONTACT_FORM_EMAIL"];
	}
	
	NSString *__message = [self.message text];
	
	if ([__message isEqualToString:@""])
		return;

	[self showProgressIndicator:@"Sending..."];

	NSString *strParams = [NSString stringWithFormat:@"name=%@&email=%@&message=%@", self.name.text, self.email.text, self.message.text ];
	NSString *url = @"http://www.lale-software.com/___igenius/contact.php";
	
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
		[self showAlertWithTitle:@"CONNECTION FAILED" message:@"We couldn't process this request at this time. Please try again later."];
	}
}

- (void) showAlertWithTitle:(NSString *)title message:(NSString *)mes {
	[UIView animateWithDuration:0.3 animations:^{
		[self.view setAlpha:0.2];
	}];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:mes
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert setBackgroundColor:[UIColor clearColor]];
	[alert show];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[UIView animateWithDuration:1.0 animations:^{
		[self.view setAlpha:1.0];
	}];
}

////////////////////////////////////////////////////////////
////////////////////		CONNECTION      ////////////////////
////////////////////////////////////////////////////////////

- (void)connectionDidFinishLoading: (NSURLConnection *)connection {
	[self hideProgressIndicator];

	NSString *result = [[NSString alloc] initWithData:self.strReceivedData encoding:NSUTF8StringEncoding];

	if ([result isEqualToString:@"Success"]) {
		[self showAlertWithTitle:@"EMAIL RECEIVED" message:@"Thank you for contacting us. We will try to respond as soon as possible if your message requires a response."];

		[self.message setText:@""];
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
	self.progressView.center = CGPointMake(160, 248);
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
