//
//  TrainingVC.m
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

#import "TrainingVC.h"
#import "Constants.h"
#import "MyButton.h"
#import "MyRndButton.h"
#import "MyTxButton.h"
#import "MyRorButton.h"
#import "MyOpButton.h"

@interface TrainingVC (Private)
- (void) initialize;
- (void) startDemo;
- (void) highlightTopBar;
- (void) highlightMidBar;
- (void) highlightRandoms;
- (void) highlightOps;
- (void) highlightTxRr;
- (void) showAlertWithNotes: (NSTimer *) timer;

- (void) exitHome;
- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle;
@end

@implementation TrainingVC

- (void) viewDidLoad {
	[super viewDidLoad];
	
	if (is_iPhone5()) {
		UIImageView *bv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 538, 320, 30)];
		bv.image = [UIImage imageNamed:@"BarBottom.png"];
		[self.view addSubview:bv];
	}
	
	[self initialize];
	[self startDemo];
}

- (void) initialize {
	UIFont *rndBtnFont = [UIFont fontWithName:@"Arial Rounded MT Bold" size:40.0];
	UIFont *opBtnFont = [UIFont fontWithName:@"Arial Rounded MT Bold" size:30.0];
	UIFont *txBtnFont = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	
	MyRndButton *myRn1 = [[MyRndButton alloc] initWithButton:self.rn1 value:0 index:0]; myRn1.button.titleLabel.font = rndBtnFont;
	MyRndButton *myRn2 = [[MyRndButton alloc] initWithButton:self.rn2 value:0 index:1]; myRn2.button.titleLabel.font = rndBtnFont;
	MyRndButton *myRn3 = [[MyRndButton alloc] initWithButton:self.rn3 value:0 index:2]; myRn3.button.titleLabel.font = rndBtnFont;
	MyRndButton *myRn4 = [[MyRndButton alloc] initWithButton:self.rn4 value:0 index:3]; myRn4.button.titleLabel.font = rndBtnFont;
	MyRndButton *myRn5 = [[MyRndButton alloc] initWithButton:self.rn5 value:0 index:4]; myRn5.button.titleLabel.font = rndBtnFont;
	MyRndButton *myRn6 = [[MyRndButton alloc] initWithButton:self.rn6 value:0 index:5]; myRn6.button.titleLabel.font = rndBtnFont;
	
	MyRorButton *myRr1 = [[MyRorButton alloc] initWithButton:self.rr1 value:0 index:0]; myRr1.button.titleLabel.font = txBtnFont;
	MyRorButton *myRr2 = [[MyRorButton alloc] initWithButton:self.rr2 value:0 index:1]; myRr2.button.titleLabel.font = txBtnFont;
	MyRorButton *myRr3 = [[MyRorButton alloc] initWithButton:self.rr3 value:0 index:2]; myRr3.button.titleLabel.font = txBtnFont;
	MyRorButton *myRr4 = [[MyRorButton alloc] initWithButton:self.rr4 value:0 index:3]; myRr4.button.titleLabel.font = txBtnFont;
	MyRorButton *myRr5 = [[MyRorButton alloc] initWithButton:self.rr5 value:0 index:4]; myRr5.button.titleLabel.font = txBtnFont;
	
	MyTxButton *myTx1 = [[MyTxButton alloc] initWithButton:self.fn1 value:0 index:0]; myTx1.button.titleLabel.font = txBtnFont;
	MyTxButton *myTx2 = [[MyTxButton alloc] initWithButton:self.fn2 value:0 index:1]; myTx2.button.titleLabel.font = txBtnFont;
	MyTxButton *myTx3 = [[MyTxButton alloc] initWithButton:self.fn3 value:0 index:2]; myTx3.button.titleLabel.font = txBtnFont;
	MyTxButton *myTx4 = [[MyTxButton alloc] initWithButton:self.fn4 value:0 index:3]; myTx4.button.titleLabel.font = txBtnFont;
	MyTxButton *myTx5 = [[MyTxButton alloc] initWithButton:self.fn5 value:0 index:4]; myTx5.button.titleLabel.font = txBtnFont;
	
	MyTxButton *myTx6 = [[MyTxButton alloc] initWithButton:self.sn1 value:0 index:0]; myTx6.button.titleLabel.font = txBtnFont;
	MyTxButton *myTx7 = [[MyTxButton alloc] initWithButton:self.sn2 value:0 index:1]; myTx7.button.titleLabel.font = txBtnFont;
	MyTxButton *myTx8 = [[MyTxButton alloc] initWithButton:self.sn3 value:0 index:2]; myTx8.button.titleLabel.font = txBtnFont;
	MyTxButton *myTx9 = [[MyTxButton alloc] initWithButton:self.sn4 value:0 index:3]; myTx9.button.titleLabel.font = txBtnFont;
	MyTxButton *myTx0 = [[MyTxButton alloc] initWithButton:self.sn5 value:0 index:4]; myTx0.button.titleLabel.font = txBtnFont;
	
	MyOpButton *myOp1 = [[MyOpButton alloc] initWithButton:self.tx1 value:-1 index:0]; myOp1.button.titleLabel.font = opBtnFont;
	MyOpButton *myOp2 = [[MyOpButton alloc] initWithButton:self.tx2 value:-1 index:1]; myOp2.button.titleLabel.font = opBtnFont;
	MyOpButton *myOp3 = [[MyOpButton alloc] initWithButton:self.tx3 value:-1 index:2]; myOp3.button.titleLabel.font = opBtnFont;
	MyOpButton *myOp4 = [[MyOpButton alloc] initWithButton:self.tx4 value:-1 index:3]; myOp4.button.titleLabel.font = opBtnFont;
	MyOpButton *myOp5 = [[MyOpButton alloc] initWithButton:self.tx5 value:-1 index:4]; myOp5.button.titleLabel.font = opBtnFont;
	
	self.rndNumButtons = [NSMutableArray arrayWithObjects:myRn1, myRn2, myRn3, myRn4, myRn5, myRn6, nil];
	self.fstNumButtons = [NSMutableArray arrayWithObjects:myTx1, myTx2, myTx3, myTx4, myTx5, nil];
	self.secNumButtons = [NSMutableArray arrayWithObjects:myTx6, myTx7, myTx8, myTx9, myTx0, nil];
	self.opertnButtons = [NSMutableArray arrayWithObjects:myOp1, myOp2, myOp3, myOp4, myOp5, nil];
	self.rowResButtons = [NSMutableArray arrayWithObjects:myRr1, myRr2, myRr3, myRr4, myRr5, nil];
	
}

//////////////////////////////////////////////////////////////////////////////
////////////////////////////    METHODS   ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) startDemo {
	NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"DemoMusic" ofType:@"caf"];
	self.demoPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:musicPath] error:nil];
	[self.demoPlayer setNumberOfLoops:-1];
	[self.demoPlayer setVolume:0.8];
	
	@try {
		[self.demoPlayer play];
	}
	@catch (NSException *e) {
		@try { [self.demoPlayer play]; }
		@catch (NSException *e) {	}
	}
	
	
	NSString *message = @"Welcome to the demo. Now we will show you what is on the game screen and how to play the game.\n\nIt is very important that you go through this demo to the end to understand the game.";
	[self showAlertWithTitle:@"~ WELCOME ~" message:message cancelTitle:@"Continue"];
}

//////////////////////////// TOP BAR ANIMATION ////////////////////////////
- (void) highlightTopBar {
	self.barHgh = [[UIImageView alloc] initWithFrame:CGRectMake(8, 17, 91, 40)];
	[self.barHgh setImage:[UIImage imageNamed:@"DemoHgh1.png"]];
	[self.barHgh setAlpha:0.0];
	[self.view addSubview:self.barHgh];

	animating = YES;
	
	[UIView animateWithDuration:1.5
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 [self.barHgh setAlpha:1.0];
						 self.barHgh.center = CGPointMake(53, 37);
					 }
					 completion:^(BOOL finished) {
						 animating = NO;
						 [self highlightTopBar2];
					 }];
}

- (void) highlightTopBar2 {
	animating = YES;
	
	[UIView animateWithDuration:1.5
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.barHgh.center = CGPointMake(158, 37);
					 }
					 completion:^(BOOL finished) {
						 animating = NO;
						 [self highlightTopBar3];
					 }];
}

- (void) highlightTopBar3 {
	animating = YES;

	[UIView animateWithDuration:1.5
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.barHgh.center = CGPointMake(265, 37);
					 }
					 completion:^(BOOL finished) {
						 animating = NO;
						 [self highlightTopBar4];
					 }];
}

- (void) highlightTopBar4 {
	animating = YES;
	
	[UIView animateWithDuration:1.5
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 [self.barHgh setAlpha:0.0];
					 }
					 completion:^(BOOL finished) {
						 animating = NO;

						 NSString *message = @"Now, let's check out the middle bar.\n\nWe see 2 buttons. ";
						 message = [message stringByAppendingString:@"The first is the timer. The second one is your target number. It will be randomly generated for every game. Your goal is to reach this number."];
						 message = [message stringByAppendingString:@"\n\nWe will highlight them in order now."];

						 [self showAlertWithTitle:@"MID BAR" message:message cancelTitle:@"Continue"];
					 }];
	
	
	[UIView setAnimationDidStopSelector:@selector(animationEnded4:finished:context:)];
	
	[UIView commitAnimations];
}
//////////////////////////// TOP BAR ANIMATION ////////////////////////////

//////////////////////////// MID BAR ANIMATION ////////////////////////////
- (void) highlightMidBar {
	self.barHgh.center = CGPointMake(98, 196);
	animating = YES;

	[UIView animateWithDuration:1.5
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 [self.barHgh setAlpha:1.0];
					 }
					 completion:^(BOOL finished) {
						 animating = NO;
						 [self highlightMidBar2];
					 }];
}

- (void) highlightMidBar2 {
	animating = YES;
	
	[UIView animateWithDuration:1.5
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.barHgh.center = CGPointMake(208, 196);
					 }
					 completion:^(BOOL finished) {
						 animating = NO;
						 [self highlightMidBar3];
					 }];
}

- (void) highlightMidBar3 {
	animating = YES;
	
	[UIView animateWithDuration:1.5
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 [self.barHgh setAlpha:0.0];
					 }
					 completion:^(BOOL finished) {
						 animating = NO;
						 [self.barHgh removeFromSuperview];
						 
						 NSString *message = @"Now, let's see the random number buttons. These are the 6 red buttons between the top bar and the middle bar. The random numbers on the first row will be between 1 and 9. The ones in the second row will be one of 25, 50, 75 and 100.";
						 message = [message stringByAppendingString:@"\n\nWe will highlight and put values in them now. You will be dragging these numbers to below during the game."];
						 [self showAlertWithTitle:@"RANDOM NUMBERS" message:message cancelTitle:@"Continue"];
					 }];
}
//////////////////////////// MID BAR ANIMATION ////////////////////////////

//////////////////////////// RANDOMS ANIMATION ////////////////////////////
- (void) highlightRandoms {
	MyButton *btn0 = (self.rndNumButtons)[0];
	MyButton *btn1 = (self.rndNumButtons)[1];
	MyButton *btn2 = (self.rndNumButtons)[2];
	MyButton *btn3 = (self.rndNumButtons)[3];
	MyButton *btn4 = (self.rndNumButtons)[4];
	MyButton *btn5 = (self.rndNumButtons)[5];

	animating = YES;
	
	[UIView animateWithDuration:2.0
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 [btn0.button setAlpha:0.0];
						 [btn1.button setAlpha:0.0];
						 [btn2.button setAlpha:0.0];
						 [btn3.button setAlpha:0.0];
						 [btn4.button setAlpha:0.0];
						 [btn5.button setAlpha:0.0];
					 }
					 completion:^(BOOL finished) {
						 [self highlightRandoms2];
					 }];
}

- (void) highlightRandoms2 {
	MyButton *btn0 = (self.rndNumButtons)[0];
	MyButton *btn1 = (self.rndNumButtons)[1];
	MyButton *btn2 = (self.rndNumButtons)[2];
	MyButton *btn3 = (self.rndNumButtons)[3];
	MyButton *btn4 = (self.rndNumButtons)[4];
	MyButton *btn5 = (self.rndNumButtons)[5];
	
	[btn0 setIntValue:7];
	[btn1 setIntValue:1];
	[btn2 setIntValue:9];
	[btn3 setIntValue:4];
	[btn4 setIntValue:75];
	[btn5 setIntValue:25];

	[UIView animateWithDuration:2.0
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 [btn0.button setAlpha:1.0];
						 [btn1.button setAlpha:1.0];
						 [btn2.button setAlpha:1.0];
						 [btn3.button setAlpha:1.0];
						 [btn4.button setAlpha:1.0];
						 [btn5.button setAlpha:1.0];
					 }
					 completion:^(BOOL finished) {
						 animating = NO;
						 
						 NSString *message = @"Now we will show you the arithmetic operation buttons. During the game, they will change values with your taps.";
						 message = [message stringByAppendingString:@"\n\nWe will highlight and put values in them now."];
						 [self showAlertWithTitle:@"ARITHMETIC OPERATIONS" message:message cancelTitle:@"Continue"];
					 }];
}
//////////////////////////// RANDOMS ANIMATION ////////////////////////////

//////////////////////////// OPS ANIMATION ////////////////////////////
- (void) highlightOps {
	MyOpButton *btn0 = (self.opertnButtons)[0];
	MyOpButton *btn1 = (self.opertnButtons)[1];
	MyOpButton *btn2 = (self.opertnButtons)[2];
	MyOpButton *btn3 = (self.opertnButtons)[3];
	MyOpButton *btn4 = (self.opertnButtons)[4];

	animating = YES;

	[UIView animateWithDuration:2.0
						  delay:0.2
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 [btn0.button setAlpha:0.0];
						 [btn1.button setAlpha:0.0];
						 [btn2.button setAlpha:0.0];
						 [btn3.button setAlpha:0.0];
						 [btn4.button setAlpha:0.0];
					 }
					 completion:^(BOOL finished) {
						 [self highlightOps2];
					 }];
}

- (void) highlightOps2 {
	MyOpButton *btn0 = (self.opertnButtons)[0];
	MyOpButton *btn1 = (self.opertnButtons)[1];
	MyOpButton *btn2 = (self.opertnButtons)[2];
	MyOpButton *btn3 = (self.opertnButtons)[3];
	MyOpButton *btn4 = (self.opertnButtons)[4];
	
	[btn0 setIntValue:0];
	[btn1 setIntValue:2];

	[UIView animateWithDuration:2.0
						  delay:0
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 [btn0.button setAlpha:1.0];
						 [btn1.button setAlpha:1.0];
						 [btn2.button setAlpha:1.0];
						 [btn3.button setAlpha:1.0];
						 [btn4.button setAlpha:1.0];
					 }
					 completion:^(BOOL finished) {
						 animating = NO;
						 
						 NSString *message = @"Let's drag some of the numbers now and see what happens.";
						 [self showAlertWithTitle:@"LET'S MOVE" message:message cancelTitle:@"Continue"];
					 }];
}
//////////////////////////// OPS ANIMATION ////////////////////////////

//////////////////////////// TXRR ANIMATION ////////////////////////////
- (void) highlightTxRr {
	UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(80, 67, 80, 43)];
	self.tempButton1 = [[MyButton alloc] initWithButton:btn1 value:1 index:0];
	
	self.tempButton1.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton1 setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
	[self.tempButton1.button setAlpha:0.9];
	[self.view addSubview:self.tempButton1.button];
	[self.view bringSubviewToFront:self.tempButton1.button];
	
	UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(240, 66, 80, 43)];
	self.tempButton2 = [[MyButton alloc] initWithButton:btn2 value:4 index:0];
	
	self.tempButton2.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton2 setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
	[self.tempButton2.button setAlpha:0.9];
	[self.view addSubview:self.tempButton2.button];
	[self.view bringSubviewToFront:self.tempButton2.button];

	animating = YES;

	[UIView animateWithDuration:3.0
						  delay:0.5
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.tempButton1.button.center = CGPointMake(40, 245);
						 self.tempButton2.button.center = CGPointMake(170, 245);
					 }
					 completion:^(BOOL finished) {
						 [self.tempButton1.button removeFromSuperview];
						 [self.tempButton2.button removeFromSuperview];
						 
						 MyTxButton *fst = (self.fstNumButtons)[0]; [fst setIntValue:1]; [fst setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
						 MyTxButton *sec = (self.secNumButtons)[0]; [sec setIntValue:4]; [sec setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
						 MyRorButton *rr = (self.rowResButtons)[0]; [rr  setIntValue:5];
						 
						 [(self.rndNumButtons)[1] setTitleColorFlue:YES];
						 [(self.rndNumButtons)[3] setTitleColorFlue:YES];
						 
						 [self highlightTxRr2];
					 }];
}

- (void) highlightTxRr2 {
	UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(240, 222, 80, 43)];
	self.tempButton1 = [[MyButton alloc] initWithButton:btn1 value:5 index:0];
	
	self.tempButton1.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton1 setBgImage:[UIImage imageNamed:@"RowResBtn.png"]];
	[self.tempButton1.button setAlpha:0.9];
	[self.view addSubview:self.tempButton1.button];
	[self.view bringSubviewToFront:self.tempButton1.button];
	
	UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(40, 120, 80, 43)];
	self.tempButton2 = [[MyButton alloc] initWithButton:btn2 value:75 index:0];
	
	self.tempButton2.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton2 setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
	[self.tempButton2.button setAlpha:0.9];
	[self.view addSubview:self.tempButton2.button];
	[self.view bringSubviewToFront:self.tempButton2.button];

	[UIView animateWithDuration:3.0
						  delay:1.0
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.tempButton1.button.center = CGPointMake(40, 287);
						 self.tempButton2.button.center = CGPointMake(170, 287);
					 }
					 completion:^(BOOL finished) {
						 animating = NO;
						 
						 [self.tempButton1.button removeFromSuperview];
						 [self.tempButton2.button removeFromSuperview];
						 
						 MyTxButton *fst = (self.fstNumButtons)[1]; [fst setIntValue:5]; [fst setBgImage:[UIImage imageNamed:@"RowResBtn.png"]];
						 MyTxButton *sec = (self.secNumButtons)[1]; [sec setIntValue:75]; [sec setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
						 MyRorButton *rr = (self.rowResButtons)[1]; [rr  setIntValue:375];
						 
						 [(self.rndNumButtons)[4] setTitleColorFlue:YES];
						 [(self.rowResButtons)[0] setTitleColorFlue:YES];
						 
						 [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showAlertWithNotes:) userInfo:nil repeats:NO];
					 }];
}

- (void) showAlertWithNotes: (NSTimer *) timer {
	NSString *message = @"We are dragging 2 numbers at the same time here as a demo, but you will be dragging one at a time.\n\nSome rules:\n\n- You can use numbers only once.\n- You can use the result number.\n- Used numbers are marked black.";
	[self showAlertWithTitle:@"PLEASE NOTE" message:message cancelTitle:@"Continue"];
}
//////////////////////////// TXRR ANIMATION ////////////////////////////

//////////////////////////// DEMO GAME ANIMATION ////////////////////////////
- (void) doFirstStep: (NSTimer *) timer {
	UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(240, 66, 80, 43)];
	self.tempButton1 = [[MyButton alloc] initWithButton:btn1 value:4 index:0];
	
	self.tempButton1.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton1 setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
	[self.tempButton1.button setAlpha:0.9];
	[self.view addSubview:self.tempButton1.button];
	[self.view bringSubviewToFront:self.tempButton1.button];
	
	UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(40, 120, 80, 43)];
	self.tempButton2 = [[MyButton alloc] initWithButton:btn2 value:75 index:0];
	
	self.tempButton2.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton2 setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
	[self.tempButton2.button setAlpha:0.9];
	[self.view addSubview:self.tempButton2.button];
	[self.view bringSubviewToFront:self.tempButton2.button];
	
	animating = YES;
	
	[UIView animateWithDuration:3.0
						  delay:0.5
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.tempButton1.button.center = CGPointMake(40, 245);
						 self.tempButton2.button.center = CGPointMake(170, 245);
					 }
					 completion:^(BOOL finished) {
						 [self.tempButton1.button removeFromSuperview];
						 [self.tempButton2.button removeFromSuperview];
						 
						 MyTxButton *fst = (self.fstNumButtons)[0]; [fst setIntValue:4]; [fst setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
						 MyTxButton *sec = (self.secNumButtons)[0]; [sec setIntValue:75]; [sec setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
						 MyRorButton *rr = (self.rowResButtons)[0]; [rr  setIntValue:300];
						 MyOpButton *op  = (self.opertnButtons)[0]; [op  setIntValue:2];
						 
						 [(self.rndNumButtons)[3] setTitleColorFlue:YES];
						 [(self.rndNumButtons)[4] setTitleColorFlue:YES];
						 
						 [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(doSecondStep:) userInfo:nil repeats:NO];
					 }];
}

- (void) doSecondStep: (NSTimer *) timer {
	UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(240, 222, 80, 43)];
	self.tempButton1 = [[MyButton alloc] initWithButton:btn1 value:300 index:0];
	
	self.tempButton1.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton1 setBgImage:[UIImage imageNamed:@"RowResBtn.png"]];
	[self.tempButton1.button setAlpha:0.9];
	[self.view addSubview:self.tempButton1.button];
	[self.view bringSubviewToFront:self.tempButton1.button];
	
	UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 120, 80, 43)];
	self.tempButton2 = [[MyButton alloc] initWithButton:btn2 value:25 index:0];
	
	self.tempButton2.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton2 setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
	[self.tempButton2.button setAlpha:0.9];
	[self.view addSubview:self.tempButton2.button];
	[self.view bringSubviewToFront:self.tempButton2.button];
	
	[UIView animateWithDuration:3.0
						  delay:1.0
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.tempButton1.button.center = CGPointMake(40, 288);
						 self.tempButton2.button.center = CGPointMake(170, 288);
					 }
					 completion:^(BOOL finished) {
						 [self.tempButton1.button removeFromSuperview];
						 [self.tempButton2.button removeFromSuperview];
						 
						 MyTxButton *fst = (self.fstNumButtons)[1]; [fst setIntValue:300]; [fst setBgImage:[UIImage imageNamed:@"RowResBtn.png"]];
						 MyTxButton *sec = (self.secNumButtons)[1]; [sec setIntValue:25]; [sec setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
						 MyRorButton *rr = (self.rowResButtons)[1]; [rr  setIntValue:325];
						 MyOpButton *op  = (self.opertnButtons)[1]; [op  setIntValue:0];
						 
						 [(self.rndNumButtons)[5] setTitleColorFlue:YES];
						 [(self.rowResButtons)[0] setTitleColorFlue:YES];
						 
						 [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(doThirdStep:) userInfo:nil repeats:NO];
					 }];
}

- (void) doThirdStep: (NSTimer *) timer {
	UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(240, 265, 80, 43)];
	self.tempButton1 = [[MyButton alloc] initWithButton:btn1 value:325 index:0];
	
	self.tempButton1.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton1 setBgImage:[UIImage imageNamed:@"RowResBtn.png"]];
	[self.tempButton1.button setAlpha:0.9];
	[self.view addSubview:self.tempButton1.button];
	[self.view bringSubviewToFront:self.tempButton1.button];
	
	UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(160, 66, 80, 43)];
	self.tempButton2 = [[MyButton alloc] initWithButton:btn2 value:9 index:0];
	
	self.tempButton2.button.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0];
	[self.tempButton2 setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
	[self.tempButton2.button setAlpha:0.9];
	[self.view addSubview:self.tempButton2.button];
	[self.view bringSubviewToFront:self.tempButton2.button];

	[UIView animateWithDuration:3.0
						  delay:1.0
						options:UIViewAnimationOptionTransitionNone
					 animations:^{
						 self.tempButton1.button.center = CGPointMake(40, 330);
						 self.tempButton2.button.center = CGPointMake(170, 330);
					 }
					 completion:^(BOOL finished) {
						 [self.tempButton1.button removeFromSuperview];
						 [self.tempButton2.button removeFromSuperview];
						 
						 MyTxButton *fst = (self.fstNumButtons)[2]; [fst setIntValue:325]; [fst setBgImage:[UIImage imageNamed:@"RowResBtn.png"]];
						 MyTxButton *sec = (self.secNumButtons)[2]; [sec setIntValue:9];	 [sec setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
						 MyRorButton *rr = (self.rowResButtons)[2]; [rr  setIntValue:334]; [rr  setBgImage:[UIImage imageNamed:@"TxRndBtn.png"]];
						 MyOpButton *op  = (self.opertnButtons)[2]; [op  setIntValue:0];
						 
						 [(self.rndNumButtons)[2] setTitleColorFlue:YES];
						 [(self.rowResButtons)[1] setTitleColorFlue:YES];
						 
						 [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(endDemo:) userInfo:nil repeats:NO];
					 }];
}

- (void) endDemo: (NSTimer *) timer {

	NSString *message = @"This is the end of demo. We STRONGLY recommend reading instructions for more detail, especially for the use of DRAG button, points, levels and modes.";
	message = [message stringByAppendingString:@"\n\nThank you for finishing the demo!"];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"END OF DEMO" 
																	message:message 
																  delegate:self 
													  cancelButtonTitle:@"Quit" 
													  otherButtonTitles:@"Instructions", nil];
	[alert setBackgroundColor:[UIColor clearColor]];
	[alert show];
	
}
//////////////////////////// DEMO GAME ANIMATION ////////////////////////////

//////////////////////////////////////////////////////////////////////////////
////////////////////////////    SHORTCUTS   ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) exitHome {
	@try {
		[self.demoPlayer stop];
	}
	@catch (NSException *e) {
		@try { [self.demoPlayer stop]; }
		@catch (NSException *e) {	}
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:MUSIC_NOTIF object:self];

	[self.navigationController popViewControllerAnimated:YES];
}

- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle {

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
																	message:message 
																  delegate:self 
													  cancelButtonTitle:cancelTitle 
													  otherButtonTitles:@"Quit", nil];
	[alert setBackgroundColor:[UIColor clearColor]];
	
	[alert show];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (buttonIndex == alertView.firstOtherButtonIndex && ![[alertView title]  isEqual: @"END OF DEMO"]) {
		[self exitHome];
		return;
	}

	if ([[alertView title]  isEqual:@"~ WELCOME ~"]) {
		NSString *message = @"First, let's start with the top bar.\n\nWe see 3 buttons. ";
		message = [message stringByAppendingString:@"The first one shows the level you are in, the second shows your current score, and the third shows your overall high score. "];
		message = [message stringByAppendingString:@"\n\nNow we will highlight them in order."];
		[self showAlertWithTitle:@"TOP BAR" message:message cancelTitle:@"Continue"];
	}
	else if ([[alertView title] isEqual: @"TOP BAR"]) {
		[self highlightTopBar];
	}
	else if ([[alertView title] isEqual: @"MID BAR"]) {
		[self highlightMidBar];
	}
	else if ([[alertView title] isEqual: @"RANDOM NUMBERS"]) {
		[self highlightRandoms];
	}
	else if ([[alertView title] isEqual: @"ARITHMETIC OPERATIONS"]) {
		[self highlightOps];
	}
	else if ([[alertView title] isEqual: @"LET'S MOVE"]) {
		[self highlightTxRr];
	}
	else if ([[alertView title] isEqual: @"PLEASE NOTE"]) {
		NSString *message = @"Now let's demo a simple game. Note the random numbers and the target number, and how we reach the target number using random numbers.\n\nWe won't run a timer in demo, but you'll have it in game.";
		[self showAlertWithTitle:@"DEMO GAME" message:message cancelTitle:@"Continue"];
	}
	else if ([[alertView title]  isEqual: @"DEMO GAME"]) {	
		animating = YES;
		
		[UIView animateWithDuration:2.5
							  delay:0.4
							options:UIViewAnimationOptionTransitionNone
						 animations:^{
							 [self.view setAlpha:0.0];
						 }
						 completion:^(BOOL finished) {
							 for (int i = 0; i < 5; i++) {
								 [(self.rndNumButtons)[i] setTitleColorFlue:NO];
								 if (i < 3) {
									 [(self.fstNumButtons)[i] setIntValue:0]; [(self.fstNumButtons)[i] setBgImage:[UIImage imageNamed:@"TxBtn.png"]];
									 [(self.secNumButtons)[i] setIntValue:0]; [(self.secNumButtons)[i] setBgImage:[UIImage imageNamed:@"TxBtn.png"]];
								 }
								 [(self.rowResButtons)[i] setIntValue:0];
								 [(self.opertnButtons)[i] setIntValue:-1];
							 }
							 [(self.rndNumButtons)[5] setTitleColorFlue:NO];
							 
							 [self.level setText:@"1"]; [self.level setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:24.0]];
							 [self.score setText:@"0"]; [self.score setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:24.0]];
							 [self.hiScore setText:@"0"]; [self.hiScore setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:24.0]];
							 [self.timer setText:@"150"]; [self.timer setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0]];
							 [self.targetNr setText:@"334"]; [self.targetNr setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:28.0]];
							 
							 [UIView animateWithDuration:2.5
												   delay:0.4
												 options:UIViewAnimationOptionTransitionNone
											  animations:^{
												  [self.view setAlpha:1.0];
											  }
											  completion:^(BOOL finished) {
												  [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(doFirstStep:) userInfo:nil repeats:NO];
											  }];
						 }];
	}
	else if ([[alertView title] isEqual: @"END OF DEMO"]) {
		if (buttonIndex == alertView.firstOtherButtonIndex) {
			[[NSNotificationCenter defaultCenter] postNotificationName:HELP_NOTIF object:self];
		}

		[self exitHome];
	}
}

@end
