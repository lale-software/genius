//
//  MatrixVC.m
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

#import "MatrixVC.h"
#import "Constants.h"
#import "Generator.h"
#import "MyDao.h"

#import "MyButton.h"
#import "MyRndButton.h"
#import "MyRorButton.h"
#import "MyOpButton.h"
#import "MyTxButton.h"

#import <math.h>

@interface MatrixVC ()

@property (nonatomic, strong) CBProgressView *progressView;

// Start - End
- (void) chooseMode;
- (void) startNewGame;
- (void) startGame:(BOOL) nextLevel isResume:(BOOL)resume;
- (void) goBackToHome;
- (void) goBackToHomeWithoutSave;
- (void) initialize;
- (void) populateFields;
- (void) deinitialize;
- (void) resetButtons;
- (void) resetButtonArrays:(NSMutableArray *)array;
- (void) endGameWithSuccess:(BOOL) success;
- (void) endingManually:(int) reachedNumber;

// Computation
- (int) checkTouchedButtonWithArray:(NSMutableArray *)buttonArray touchPosition:(CGPoint)position;
- (void) operationPressed:(int)i;
- (void) doCalculate;
- (void) checkIntegrity;
- (void) doCalculateForAnimation;
- (int) rrWfn:(int) fn op:(int) op sn:(int) sn;
- (NSArray *) calculatePoints: (NSString *) type difference:(int) difference;

// Shortcuts
- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancel otherTitles:(NSArray *)others;
- (void) setViewAlpha:(CGFloat) alpha duration:(NSTimeInterval) duration;
- (void) updateHighScore;
- (void) startGameMusic;
- (void) startAnimMusic;
- (void) playNewMode: (NSTimer *) timer;
- (void) playButtonMoved: (NSTimer *) timer;
- (void) opPressed: (NSTimer *) timer;
- (void) playCountdown: (NSTimer *) timer;
- (void) gameOverSuccess: (NSTimer *) timer;
- (void) gameOverFailed: (NSTimer *) timer;
- (void) startTimers;
- (void) stopTimers;
- (void) exitHome;
- (void) touchTimers:(NSNotification *)notif;

- (void) showProgressIndicator:(NSString *)label;
- (void) hideProgressIndicator;

// Animation
- (void) animateSolution:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
//- (void) animateSolutionBack:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (MyButton *) getButtonWithGroup:(NSString *)group index:(int) index;
- (void) lockButtons;
@end

@implementation MatrixVC

- (void) viewDidLoad {
	
	[super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES animated:NO];

	if (is_iPhone5()) {
		UIImageView *bv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 538, 320, 30)];
		bv.image = [UIImage imageNamed:@"BarBottom.png"];
		[self.view addSubview:bv];
	}
	
	[self deinitialize];
	[self initialize];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(touchTimers:) name:INTER_NOTIF object:nil];

	[self chooseMode];

	inGame = YES;
}

- (void) dealloc {
	if (self.countdown.isValid)
		[self.countdown invalidate];
	if (self.resultCheck.isValid)
		[self.resultCheck invalidate];

	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
		if (tempAnimIndex > -2)
			return;

		[self resetButtons];
	}
}

- (void) viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void) initialize {
	UIFont *rndBtnFont = [UIFont fontWithName:@"LithosPro-Black" size:30.0];
	UIFont *opBtnFont = [UIFont fontWithName:@"LithosPro-Black" size:30.0];
	UIFont *txBtnFont = [UIFont fontWithName:@"LithosPro-Black" size:24.0];
	
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
	
	self.manualEndBtn = [[MyButton alloc] initWithButton:self.manualEndDragBtn value:0 index:0];
	
	self.rndNumButtons = [NSMutableArray arrayWithObjects:myRn1, myRn2, myRn3, myRn4, myRn5, myRn6, nil];
	self.fstNumButtons = [NSMutableArray arrayWithObjects:myTx1, myTx2, myTx3, myTx4, myTx5, nil];
	self.secNumButtons = [NSMutableArray arrayWithObjects:myTx6, myTx7, myTx8, myTx9, myTx0, nil];
	self.opertnButtons = [NSMutableArray arrayWithObjects:myOp1, myOp2, myOp3, myOp4, myOp5, nil];
	self.rowResButtons = [NSMutableArray arrayWithObjects:myRr1, myRr2, myRr3, myRr4, myRr5, nil];

	[self.levelLbl setFont:[UIFont fontWithName:@"LithosPro-Black" size:24.0]];
	self.levelLbl.layer.shadowColor = [UIColor blackColor].CGColor;
	self.levelLbl.layer.shadowOffset = CGSizeMake(2.0, 2.0);
	self.levelLbl.layer.shadowRadius = 3.0;
	self.levelLbl.layer.shadowOpacity = 0.5;
	self.levelLbl.layer.masksToBounds = NO;

	[self.scoreLbl setFont:[UIFont fontWithName:@"LithosPro-Black" size:24.0]];
	self.scoreLbl.layer.shadowColor = [UIColor blackColor].CGColor;
	self.scoreLbl.layer.shadowOffset = CGSizeMake(2.0, 2.0);
	self.scoreLbl.layer.shadowRadius = 3.0;
	self.scoreLbl.layer.shadowOpacity = 0.5;
	self.scoreLbl.layer.masksToBounds = NO;

	[self.hiScoreLbl setFont:[UIFont fontWithName:@"LithosPro-Black" size:24.0]];
	self.hiScoreLbl.layer.shadowColor = [UIColor blackColor].CGColor;
	self.hiScoreLbl.layer.shadowOffset = CGSizeMake(2.0, 2.0);
	self.hiScoreLbl.layer.shadowRadius = 3.0;
	self.hiScoreLbl.layer.shadowOpacity = 0.5;
	self.hiScoreLbl.layer.masksToBounds = NO;
	
	[self.timerLbl setFont:txBtnFont];
	self.timerLbl.layer.shadowColor = [UIColor blackColor].CGColor;
	self.timerLbl.layer.shadowOffset = CGSizeMake(2.0, 2.0);
	self.timerLbl.layer.shadowRadius = 3.0;
	self.timerLbl.layer.shadowOpacity = 0.5;
	self.timerLbl.layer.masksToBounds = NO;

	[self.targetNrLbl setFont:txBtnFont];
	self.targetNrLbl.layer.shadowColor = [UIColor blackColor].CGColor;
	self.targetNrLbl.layer.shadowOffset = CGSizeMake(2.0, 2.0);
	self.targetNrLbl.layer.shadowRadius = 3.0;
	self.targetNrLbl.layer.shadowOpacity = 0.5;
	self.targetNrLbl.layer.masksToBounds = NO;
	
	self.rndNormal = [UIImage imageNamed:BG_RND_BTN_L];
	self.rndLong = [UIImage imageNamed:BG_RND_BTN_LNG_L];
	self.rrImage = [UIImage imageNamed:BG_ROW_BTN];
	self.txImage = [UIImage imageNamed:BG_TX_BTN];
	
	sound = [Utils boolForKey:GAME_SOUND_SET] ? [Utils boolForKey:GAME_SOUND] : YES;
	music = [Utils boolForKey:GAME_MUSIC_SET] ? [Utils intForKey:GAME_MUSIC] > 0 : YES;

	showNewModeAlert = YES;

	NSString *gameMusicPath;
	
	if ([Utils boolForKey:GAME_MUSIC_SET] == NO) {
		gameMusicPath = [[NSBundle mainBundle] pathForResource:@"GameMusicTrack2" ofType:@"caf"];
	}
	else {
		if ([Utils intForKey:GAME_MUSIC] == 0) {
			gameMusicPath = [[NSBundle mainBundle] pathForResource:@"GameMusicTrack2" ofType:@"caf"];
		}
		else if ([Utils intForKey:GAME_MUSIC] == 1) {
			gameMusicPath = [[NSBundle mainBundle] pathForResource:@"GameMusicTrack3" ofType:@"caf"];
		}
		else if ([Utils intForKey:GAME_MUSIC] == 2) {
			gameMusicPath = [[NSBundle mainBundle] pathForResource:@"GameMusicTrack2" ofType:@"caf"];
		}
		else {
			gameMusicPath = [[NSBundle mainBundle] pathForResource:@"DemoMusic" ofType:@"caf"];
		}
	}
	self.musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:gameMusicPath] error:nil];

	NSString *btnMovedMusicPath = [[NSBundle mainBundle] pathForResource:@"ButtonMoved" ofType:@"caf"];
	self.dragPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:btnMovedMusicPath] error:nil];

	NSString *opPressedMusicPath = [[NSBundle mainBundle] pathForResource:@"OpPressed" ofType:@"caf"];
	self.opPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opPressedMusicPath] error:nil];
	self.countdownPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:opPressedMusicPath] error:nil];
	
	NSString *gameOverSuccessPath = [[NSBundle mainBundle] pathForResource:@"GameOverSuccess" ofType:@"wav"];
	self.gameOverSuccessPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:gameOverSuccessPath] error:nil];

	NSString *gameOverFailPath = [[NSBundle mainBundle] pathForResource:@"GameOverFail" ofType:@"caf"];
	self.gameOverFailPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:gameOverFailPath] error:nil];
}

- (void) deinitialize {
	self.rndNumButtons = nil;
	self.fstNumButtons = nil;
	self.secNumButtons = nil;
	self.opertnButtons = nil;
	self.rowResButtons = nil;
}

//////////////////////////////////////////////////////////////////////////////
////////////////////////////    TOUCHES   ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (tempAnimIndex != -2)
		return;
	
	UITouch *touch = [[event allTouches] anyObject];
	CGPoint position = [touch locationInView:self.view];
	
	int opIndex = [self checkTouchedButtonWithArray:self.opertnButtons touchPosition:position];
	if (opIndex != -1) { [self operationPressed:opIndex];	return; } 
	
	self.touchedButton = nil;
	self.tempButton = nil;
	
	int rndIndex = [self checkTouchedButtonWithArray:self.rndNumButtons touchPosition:position];
	if (rndIndex != -1 && [(self.rndNumButtons)[rndIndex] ifUsed] == NO) {
		self.touchedButton = (self.rndNumButtons)[rndIndex];
	}
	
	if (self.touchedButton == nil) {
		int rrIndex = [self checkTouchedButtonWithArray:self.rowResButtons touchPosition:position];
		if (rrIndex != -1 && [(self.rowResButtons)[rrIndex] ifUsed] == NO) {
			self.touchedButton = (self.rowResButtons)[rrIndex];
		}
	}
	
	if (self.touchedButton == nil) {
		int fnIndex = [self checkTouchedButtonWithArray:self.fstNumButtons touchPosition:position];
		if (fnIndex != -1 && [(self.fstNumButtons)[fnIndex] ifUsed] == YES) {
			self.touchedButton = (self.fstNumButtons)[fnIndex];
		}
	}
	
	if (self.touchedButton == nil) {
		int snIndex = [self checkTouchedButtonWithArray:self.secNumButtons touchPosition:position];
		if (snIndex != -1 && [(self.secNumButtons)[snIndex] ifUsed] == YES) {
			self.touchedButton = (self.secNumButtons)[snIndex];
		}
	}

	if (self.touchedButton != nil) {
		[self.touchedButton setTitleColorFlue:YES];
		CGRect tmpBtnFrame = CGRectMake(self.touchedButton.button.center.x - 36, self.touchedButton.button.center.y - 18, 72, 36);
		UIButton *btn = [[UIButton alloc] initWithFrame:tmpBtnFrame];
		tempOrigLocation = btn.center;
		self.tempButton = [[MyButton alloc] initWithButton:btn value:[self.touchedButton getIntValue] index:0];

		self.tempButton.button.titleLabel.font = [UIFont fontWithName:@"LithosPro-Black" size:28.0];
		[self.tempButton setBgImage:self.touchedButton.button.currentBackgroundImage];
		[self.tempButton.button setAlpha:0.9];
		[self.view addSubview:self.tempButton.button];
		[self.view bringSubviewToFront:self.tempButton.button];

		[UIView animateWithDuration:0.1
						 animations:^{
							 CGAffineTransform transform = CGAffineTransformMakeScale(1.1, 1.1);
							 self.tempButton.button.transform = transform;
						 }];
	}
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	if (self.tempButton == nil || tempAnimIndex != -2)
		return;

	UITouch *touch = [[event allTouches] anyObject];
	CGPoint position = [touch locationInView:self.view];
	UIImage *normalImg = [UIImage imageNamed:BG_TX_BTN], *normalImgLast = [UIImage imageNamed:BG_TX_BTN_LAST], *hghImg = [UIImage imageNamed:BG_TX_HGH_BTN];

	self.tempButton.button.center = CGPointMake(position.x, position.y - 10);
	BOOL highlight = YES;

	MyTxButton *txBtn = nil;
	for (int i = 0; i < 5; i++) {
		MyTxButton *ftxBtn = (self.fstNumButtons)[i], *stxBtn = (self.secNumButtons)[i];
		if (CGRectContainsPoint([self.tempButton.button frame], ftxBtn.button.center)) {
			txBtn = ftxBtn; break;
		}
		if (CGRectContainsPoint([self.tempButton.button frame], stxBtn.button.center)) {
			txBtn = stxBtn; break;
		}
	}

	MyTxButton *fstTouched = nil, *secTouched = nil; MyRorButton *rorTouched = nil;

	if (txBtn == nil)	
		highlight = NO;
	else {
		if		([self.rowResButtons indexOfObject:self.touchedButton] != NSNotFound) rorTouched = (MyRorButton *) self.touchedButton;
		else if	([self.fstNumButtons indexOfObject:self.touchedButton] != NSNotFound) fstTouched = (MyTxButton *) self.touchedButton;
		else if	([self.secNumButtons indexOfObject:self.touchedButton] != NSNotFound) secTouched = (MyTxButton *) self.touchedButton;

		// Row result, ayni veya ust rowlara drag edilememeli.
		if (rorTouched != nil) {
			if ([rorTouched getIndex] >= [txBtn getIndex]) 
				highlight = NO;
		}
		else if (fstTouched != nil) {
			if (fstTouched.isRRButton) {
				if ([txBtn getIndex] <= [fstTouched.btnHeld getIndex]) 
					highlight = NO;
			}
		}
		else if (secTouched != nil) {
			if (secTouched.isRRButton) {
				if ([txBtn getIndex] <= [secTouched.btnHeld getIndex]) 
					highlight = NO;
			}
		}
	}
	
	for (int i = 0; i < 5; i++) {
		MyTxButton *btn = (self.fstNumButtons)[i];
		if (highlight && btn == txBtn && btn != secTouched) {
			if (btn.isUsed) {
				if (btn.actualBgImage == nil)
					btn.actualBgImage = btn.button.currentBackgroundImage;
			}
			[btn setBgImage:hghImg];
		}
		else {
			if (btn.isUsed) {
				if (btn.actualBgImage != nil) {
					[btn setBgImage:btn.actualBgImage];
					btn.actualBgImage = nil;
				}
			}
			else {
				[btn setBgImage:(i < 4)?normalImg:normalImgLast];
			}
		}
		
		btn = (self.secNumButtons)[i];
		if (highlight && btn == txBtn && btn != secTouched) {
			if (btn.isUsed) {
				if (btn.actualBgImage == nil)
					btn.actualBgImage = btn.button.currentBackgroundImage;
			}
			[btn setBgImage:hghImg];
		}
		else {
			if (btn.isUsed) {
				if (btn.actualBgImage != nil) {
					[btn setBgImage:btn.actualBgImage];
					btn.actualBgImage = nil;
				}
			}
			else {
				[btn setBgImage:(i < 4)?normalImg:normalImgLast];
			}
		}
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	if (tempAnimIndex != -2)
		return;
	
	// Correct tx bg images, just in case
	for (int i = 0; i < 5; i++) {
		MyTxButton *btn;
		btn = (self.fstNumButtons)[i]; btn.actualBgImage = nil;
		if (btn.isUsed) [btn setBgImage:(btn.isRRButton) ? self.rrImage : [UIImage imageNamed:BG_TX_RND_BTN]];
		else [btn setBgImage:(i == 4) ? [UIImage imageNamed:BG_TX_BTN_LAST] : self.txImage];
		
		btn = (self.secNumButtons)[i]; btn.actualBgImage = nil;
		if (btn.isUsed) [btn setBgImage:(btn.isRRButton) ? self.rrImage : [UIImage imageNamed:BG_TX_RND_BTN]];
		else [btn setBgImage:(i == 4) ? [UIImage imageNamed:BG_TX_BTN_LAST] : self.txImage];
	}
	
	if (self.tempButton == nil)
		return;

	UITouch *touch = [[event allTouches] anyObject];
	CGPoint position = [touch locationInView:self.view];
	
	int copiedNumber = [self.tempButton getIntValue]; // Tasinan sayi.
	
	// Check if tried to end manually
	if (CGRectContainsPoint([self.manualEndDragBtn frame], position)) {

		BOOL success = NO;
		int difference = abs(copiedNumber - targetNr);

		if (level <= 10) success = (difference <= 10);
		else if (level <= 20) success = (difference <= 8);
		else success = (difference <= 5);
		
		[self.touchedButton setIntValue:copiedNumber];
		[self.touchedButton setTitleColorFlue:NO];
		[self.tempButton.button removeFromSuperview];
		self.tempButton = nil;
		
		if (success) {
			[self stopTimers];
			[self endingManually:difference];
		}

		return;
	}
	
	// Birakildigi yeri kontrol et, dogru yerde mi diye. Degilse degerleri geri koy ve cik.
	int fnIndex = [self checkTouchedButtonWithArray:self.fstNumButtons touchPosition:position];
	int snIndex = [self checkTouchedButtonWithArray:self.secNumButtons touchPosition:position];
	int txIndex = (fnIndex == -1 && snIndex == -1) ? -1 : ((fnIndex == -1) ? snIndex : fnIndex);
	
	// Birakilan buton
	MyTxButton *txBtnMovedUpon = (txIndex == -1) ? nil : (fnIndex != -1?(self.fstNumButtons)[fnIndex]:(self.secNumButtons)[snIndex]);
	
	if (txBtnMovedUpon == nil || txBtnMovedUpon == self.touchedButton) {
		[self.touchedButton setIntValue:copiedNumber];
		[self.tempButton.button removeFromSuperview];
		[self.touchedButton setTitleColorFlue:NO];
		self.tempButton = nil;
		return;
	}
	
	MyRorButton *rorBtnTouched = ([self.rowResButtons indexOfObject:self.touchedButton] == NSNotFound)?nil:(MyRorButton *) self.touchedButton;
	
	// Row result, ayni veya ust rowlara drag edilememeli.
	if (rorBtnTouched != nil && [rorBtnTouched getIndex] >= txIndex) {
		[self.touchedButton setIntValue:copiedNumber];
		[self.tempButton.button removeFromSuperview];
		[self.touchedButton setTitleColorFlue:NO];
		self.tempButton = nil;
		return;
	}
	
	// touched buton fst veya sec number mi diye kontrol et
	MyTxButton *fstTouched = ([self.fstNumButtons indexOfObject:self.touchedButton] != NSNotFound) ? (MyTxButton *) self.touchedButton : nil;
	MyTxButton *secTouched = ([self.secNumButtons indexOfObject:self.touchedButton] != NSNotFound) ? (MyTxButton *) self.touchedButton : nil;
	BOOL fstOrSecTouched = (fstTouched != nil || secTouched != nil);
	MyTxButton *txBtnTouched = (fstOrSecTouched == YES) ? (MyTxButton *) self.touchedButton : nil;
	
	// row result yukari tasiniyor mu kontrol et.
	if (fstOrSecTouched == YES && txBtnTouched.isRRButton == YES) {
		MyRorButton *rrBtn = (MyRorButton *) txBtnTouched.btnHeld;
		
		if ([rrBtn getIndex] >= txIndex) {
			[self.touchedButton setIntValue:copiedNumber];
			[self.tempButton.button removeFromSuperview];
			[self.touchedButton setTitleColorFlue:NO];
			self.tempButton = nil;
			return;
		}
	}
	
	// Birakilan butonda rakam mevcut mu?
	if (txBtnMovedUpon.isUsed == YES) {
		int copiedIndex = [txBtnMovedUpon.btnHeld getIndex];
		
		if ([self.rndNumButtons indexOfObject:txBtnMovedUpon.btnHeld] != NSNotFound) {
			MyRndButton *rndButton = (self.rndNumButtons)[copiedIndex];
			[rndButton setIntValue:[txBtnMovedUpon getIntValue]];
			[rndButton setTitleColorFlue:NO];
			rndButton.isUsed = NO;
		}
		else if ([self.rowResButtons indexOfObject:txBtnMovedUpon.btnHeld] != NSNotFound) {
			MyRorButton *rrBtn = (self.rowResButtons)[copiedIndex];
			[rrBtn setIntValue:[txBtnMovedUpon getIntValue]];
			[rrBtn setTitleColorFlue:NO];
			rrBtn.dependingBtn = nil;
			rrBtn.isUsed = NO;
		}
	}

	// Tx button BG imagi degistir
	if (fstOrSecTouched || rorBtnTouched) {
		[txBtnMovedUpon setBgImage:self.touchedButton.button.currentBackgroundImage];
		[txBtnTouched setBgImage:(txIndex < 4) ? self.txImage : [UIImage imageNamed:BG_TX_BTN_LAST]];
	}
	else {
		[txBtnMovedUpon setBgImage:[UIImage imageNamed:BG_TX_RND_BTN]];
	}
	
	self.touchedButton.isUsed = (fstOrSecTouched == NO);
	[self.touchedButton setTitleColorFlue:(fstOrSecTouched == NO)];
	[self.touchedButton setIntValue:(fstOrSecTouched ? 0 : copiedNumber)];
	
	txBtnMovedUpon.isUsed = YES;
	txBtnMovedUpon.isRRButton = (fstOrSecTouched == YES) ? txBtnTouched.isRRButton : (rorBtnTouched != nil);
	txBtnMovedUpon.btnHeld = (fstOrSecTouched == YES) ? txBtnTouched.btnHeld : self.touchedButton;
	[txBtnMovedUpon setIntValue:copiedNumber];
	
	// ror buton ise depending buton ekle
	if (rorBtnTouched != nil) {
		rorBtnTouched.dependingBtn = txBtnMovedUpon;
   }
	
	// temp butonu yok et
	[self.tempButton.button removeFromSuperview];
	self.tempButton = nil;

	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(playButtonMoved:) userInfo:nil repeats:NO];

	// Calculate all rows
	[self doCalculate];

	// Correct tx bg images, just in case
	for (int i = 0; i < 5; i++) {
		MyTxButton *btn;
		btn = (self.fstNumButtons)[i]; btn.actualBgImage = nil;
		if (btn.isUsed) [btn setBgImage:(btn.isRRButton) ? self.rrImage : [UIImage imageNamed:BG_TX_RND_BTN]];
		else				 [btn setBgImage:(i == 4) ? [UIImage imageNamed:BG_TX_BTN_LAST] : self.txImage];
		
		btn = (self.secNumButtons)[i]; btn.actualBgImage = nil;
		if (btn.isUsed) [btn setBgImage:(btn.isRRButton) ? self.rrImage : [UIImage imageNamed:BG_TX_RND_BTN]];
		else				 [btn setBgImage:(i == 4) ? [UIImage imageNamed:BG_TX_BTN_LAST] : self.txImage];
	}
}

- (int) checkTouchedButtonWithArray:(NSMutableArray *)buttonArray touchPosition:(CGPoint)position {
	
	BOOL found = NO;
	int i = 0;
	for (i = 0; i < [buttonArray count]; i++) {
		MyButton *btn = buttonArray[i];
		if (CGRectContainsPoint([btn.button frame], position)) {
			found = YES;
			break;
		}
	}
	
	if (found && [buttonArray isEqualToArray:self.rowResButtons]) {
		if ([(self.rowResButtons)[i] getIntValue] == 0)
			return -1;
	}
	
	return found?i:-1;
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self touchesEnded:touches withEvent:event];
}

//////////////////////////////////////////////////////////////////////////////
////////////////////////////    IBACTIONS   /////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (IBAction) startNewGame:(id)sender {
	if (tempAnimIndex == -2) {
		[Utils saveBool:YES forKey:ALERTONDISPLAY];

		// music player stop
		@try { [self.musicPlayer pause]; }
		@catch (NSException * e) {
			@try { [self.musicPlayer pause]; }
			@catch (NSException * e) { }
		}

		[self showAlertWithTitle:@"NEW GAME?" message:@"This will start a new game and reset your current points. Are you sure?" 
						 cancelTitle:@"NO" otherTitles:[NSMutableArray arrayWithObjects:@"YES", nil]];
	}
	else if (tempAnimIndex == -1) {
		// anim player stop
		@try { [self.animPlayer stop]; }
		@catch (NSException * e) {
			@try { [self.animPlayer stop]; }
			@catch (NSException * e) { }
		}

		if (goToNextLevel) {
			[self startGame:YES isResume:NO];
		}
		else {
			[self chooseMode];
		}
	}
}

- (IBAction) goBackToHome:(id)sender {
	if (tempAnimIndex == -2) {

		if (score == 0) {
			[self exitHome];
			return;
		}

		if ((currentLevelTimeLeft - timeLeft) <= 10) {
			[self goBackToHome];
		}
		else {
			[self goBackToHomeWithoutSave];
		}
	}

	if (tempAnimIndex == -1) {
		
		if (goToNextLevel) {
			[self goBackToHome];
		}
		else {
			[Utils saveBool:NO forKey:SAVED_GAME];

			[self exitHome];	
		}
	}
}

- (IBAction) resetButtons:(id)sender {
	if (tempAnimIndex == -2) {
		[self resetButtons];
	}
}

- (void) startNewGame {
	[Utils saveInt:0 forKey:CURRENTSCORE];

	[self stopTimers];
	[self startGame:NO isResume:NO];
}

- (void) goBackToHome {
	[Utils saveBool:YES forKey:ALERTONDISPLAY];

	[self showAlertWithTitle:@"QUIT?" message:@"Would you like to save this game and continue later?\n\n" 
					 cancelTitle:@"BACK TO GAME" otherTitles:[NSMutableArray arrayWithObjects:@"SAVE & EXIT", @"JUST EXIT", nil]];
}

- (void) goBackToHomeWithoutSave {
	[Utils saveBool:YES forKey:ALERTONDISPLAY];
	
	[self showAlertWithTitle:@"ARE YOU SURE?" message:@"Are you sure you want to quit? This will end your game and reset your points.\n\n" 
					 cancelTitle:@"NO" otherTitles:[NSMutableArray arrayWithObjects:@"YES", nil]];
}

- (void) resetButtons {
	[self resetButtonArrays:self.fstNumButtons];
	[self resetButtonArrays:self.secNumButtons];
	[self resetButtonArrays:self.opertnButtons];
	[self resetButtonArrays:self.rowResButtons];
	
	for (int i = 0; i < 6; i++) {
		MyRndButton *rndBtn = (self.rndNumButtons)[i];
		[rndBtn setIsUsed:NO];
		[rndBtn setTitleColorFlue:NO];
	}
}

- (void) lockButtons {

	for (int i = 0; i < 5; i++) {
		MyButton *btn1 = (self.rowResButtons)[i];	btn1.isUsed = YES;
		MyButton *btn2 = (self.rndNumButtons)[i];	btn2.isUsed = YES;
		MyButton *btn3 = (self.fstNumButtons)[i];	btn3.isUsed = NO;
		MyButton *btn4 = (self.secNumButtons)[i];	btn4.isUsed = NO;

	}
	MyButton *btn = (self.rndNumButtons)[5];	btn.isUsed = YES;
}

//////////////////////////////////////////////////////////////////////////////
////////////////////////////    METHODS   ///////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (void) chooseMode {
	if ([Utils boolForKey:SAVED_GAME]) {
		[self showAlertWithTitle:@"RESUME GAME?" message:@"Would you like to resume your game?\n\n" 
						 cancelTitle:@"NO" otherTitles:[NSMutableArray arrayWithObjects:@"YES", nil]];
		return;
	}

	if ([Utils boolForKey:INTERRUPTED] && [Utils boolForKey:IN_GAME]) {
		[self showAlertWithTitle:@"RESUME INTERRUPTED GAME?" message:@"Would you like to continue from where you were?\n\n"
						 cancelTitle:@"NO" otherTitles:[NSMutableArray arrayWithObjects:@"YES", nil]];
		return;
	}

	insertScore = NO;
	
	int easyModeScore = [Utils intForKey:EASY_MODE];
	int mediumModeScore = [Utils intForKey:MEDIUM_MODE];
	BOOL bypass = [Utils boolForKey:BYPASS_MODES];

	if (easyModeScore > 0) {
		if (bypass) {
			if (mediumModeScore > 0) {
				showNewModeAlert = NO;
				level = 20;
				score = [[NSUserDefaults standardUserDefaults] integerForKey:MEDIUM_MODE];
				[self.scoreLbl setText:[NSString stringWithFormat:@"%d", score]];
				[self startGame:YES isResume:NO];
			}
			else {
				showNewModeAlert = NO;
				level = 10;
				score = [[NSUserDefaults standardUserDefaults] integerForKey:EASY_MODE];
				[self.scoreLbl setText:[NSString stringWithFormat:@"%d", score]];
				[self startGame:YES isResume:NO];
			}
		}
		else {
			NSString *message = @"You have previously finished EASY ";
			
			if (mediumModeScore > 0)	message = [message stringByAppendingString:@"and MEDIUM modes."];
			else								message = [message stringByAppendingString:@"mode."];
			
			message = [message stringByAppendingString:@" You can choose which mode to start.\n\n"];
			message = [message stringByAppendingString:@"Please remember that you will start with the highest points you have accumulated for the finished modes, listed below.\n\n"];
			message = [message stringByAppendingString:[NSString stringWithFormat:@"EASY mode: %d", easyModeScore]];
			if (mediumModeScore > 0)
				message = [message stringByAppendingString:[NSString stringWithFormat:@"\nMEDIUM mode: %d", mediumModeScore]];		

			NSMutableArray *others = [NSMutableArray arrayWithObjects:@"EASY", @"MEDIUM", nil];
		
			if (mediumModeScore > 0)
				[others addObject:@"GENIUS"];
			
			[self showAlertWithTitle:@"Choose mode to start" message:message cancelTitle:nil otherTitles:others];
		}
	}
	else {
		[self startNewGame];
	}
}

- (void) startGame: (BOOL) nextLevel isResume:(BOOL) resume {
	
	[self resetButtonArrays:self.rndNumButtons];
	[self resetButtonArrays:self.fstNumButtons];
	[self resetButtonArrays:self.secNumButtons];
	[self resetButtonArrays:self.opertnButtons];
	[self resetButtonArrays:self.rowResButtons];

	for (int i = 0; i < 5; i++) { // Backgroundlari fix et, just in case
		[(self.fstNumButtons)[i] setBgImage:(i == 4) ? [UIImage imageNamed:BG_TX_BTN_LAST] : self.txImage];
		[(self.secNumButtons)[i] setBgImage:(i == 4) ? [UIImage imageNamed:BG_TX_BTN_LAST] : self.txImage];
	}
	
	[self setViewAlpha:1.0 duration:0.5];
	
	if (nextLevel == NO) {
		level = 1; [self.levelLbl setText:[NSString stringWithFormat:@"%d", level]];
		score = 0; [self.scoreLbl setText:[NSString stringWithFormat:@"%d", score]];
	}
	else {
		[self.levelLbl setText:[NSString stringWithFormat:@"%d", resume ? level : ++level]];
		[self.scoreLbl setText:[NSString stringWithFormat:@"%d", score]];
	}

	hiScore = [[NSUserDefaults standardUserDefaults] integerForKey:HIGHSCORE];
	[self.hiScoreLbl setText:[NSString stringWithFormat:@"%d", hiScore]];
	
	if	(level <= 10) {
		timeNegator = 3;
		currentLevelTimeLeft = [TIME_LEFT intValue] - ((level - 1) * timeNegator);
	} 
	else if (level <= 20) {
		timeNegator = 2;
		currentLevelTimeLeft = ([TIME_LEFT intValue] - 30) - ((level - 11) * timeNegator);
	} 
	else {
		timeNegator = 1;
		
		if (level > 60) {
			currentLevelTimeLeft = 60;
		}
		else {
			currentLevelTimeLeft = ([TIME_LEFT intValue] - 50) - ((level - 21) * timeNegator);
		}
	}
	
	timeLeft = currentLevelTimeLeft;
	
	goToNextLevel = NO;
	[self.startNewGameBtn setBackgroundImage:[UIImage imageNamed:@"NewGameBarBtn.png"] forState:UIControlStateNormal];
	[self.startNewGameBtn setBackgroundImage:[UIImage imageNamed:@"NewGameBarBtnHgh.png"] forState:UIControlStateHighlighted];

	if (level == 1) {
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(playNewMode:) userInfo:nil repeats:NO];
		[self showAlertWithTitle:@"NEW GAME!" message:@"You are starting with EASY mode!" cancelTitle:@"GO" otherTitles:nil];
	}
	else if (level == 11) {
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(playNewMode:) userInfo:nil repeats:NO];
		NSString *title = (showNewModeAlert) ? @"NEW MODE!" : @"NEW GAME!";
		NSString *message = (showNewModeAlert) ? @"Now you are in the MEDIUM mode!" : @"You are starting with MEDIUM mode!";;
		
		[self showAlertWithTitle:title message:message cancelTitle:@"GO" otherTitles:nil];
		showNewModeAlert = YES;
	}
	else if (level == 21) {
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(playNewMode:) userInfo:nil repeats:NO];
		NSString *title = (showNewModeAlert) ? @"NEW MODE!" : @"NEW GAME!";
		NSString *message = (showNewModeAlert) ? @"Now you are in the GENIUS mode!" : @"You are starting with GENIUS mode!";;

		[self showAlertWithTitle:title message:message cancelTitle:@"GO" otherTitles:nil];
		showNewModeAlert = YES;
	}
	else {
		[self.manualEndBtn setBgImage:[UIImage imageNamed:@"DragBarBtnOff.png"]];

		[self showProgressIndicator:@"Please Wait..."];
		[self performSelectorInBackground:@selector(populateFields) withObject:nil];
		[self hideProgressIndicator];
	}
}

- (void) resetButtonArrays:(NSMutableArray *)array {
	MyButton *btn;
	
	for (int i = 0; i < [array count]; i++) {
		btn = array[i];
		if ([array isEqualToArray:self.opertnButtons])
			[btn setIntValue:-1];
		else
			[btn setIntValue:0];
		
		btn.isUsed = NO;
		[btn setTitleColorFlue:NO];
	}
	
	for (int i = 0; i < 4; i++) {
		[(MyRorButton *)(self.rowResButtons)[i] setBgImage:self.rrImage];
		[(MyTxButton *)(self.fstNumButtons)[i] setBgImage:self.txImage];
		[(MyTxButton *)(self.secNumButtons)[i] setBgImage:self.txImage];
	}
	[(MyRorButton *)(self.rowResButtons)[4] setBgImage:[UIImage imageNamed:BG_ROW_BTN_LAST]];
	[(MyTxButton *)(self.fstNumButtons)[4] setBgImage:[UIImage imageNamed:BG_TX_BTN_LAST]];
	[(MyTxButton *)(self.secNumButtons)[4] setBgImage:[UIImage imageNamed:BG_TX_BTN_LAST]];
	
}

- (void) populateFields {
	@autoreleasepool {
		[self.timerLbl setText:[NSString stringWithFormat:@"%d", timeLeft]];

		int phase;
		if (level < 11)		phase = 1;
		else if (level < 21)	phase = 2;
		else	phase = 3;

		NSArray *array = [Generator generateGameInPhase:phase];
		NSArray *rndNums = array[0];
		NSNumber *targetNumber = array[1];
		self.solution = array[2];
		
		for (int i = 0; i < 6; i++) {
			int gn = [rndNums[i] intValue];
			[(self.rndNumButtons)[i] setIntValue:gn];
		}
		
		targetNr = [targetNumber intValue];
		[self.targetNrLbl setText:[NSString stringWithFormat:@"%d", targetNr]];
		
		tempAnimIndex = -2;
		[self performSelectorOnMainThread:@selector(startTimers) withObject:nil waitUntilDone:NO];
		[self performSelectorOnMainThread:@selector(startGameMusic) withObject:nil waitUntilDone:NO];
	}
}

- (void) operationPressed:(int) i {
	
	if ([(self.fstNumButtons)[i] ifUsed] == NO && [(self.secNumButtons)[i] ifUsed] == NO)
		return;
	
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(opPressed:) userInfo:nil repeats:NO];
	
	MyButton *btn = (self.opertnButtons)[i];
	int tx = btn.value;
	tx++;
	tx = tx % 4;
	[btn setIntValue:tx];
	
	[self doCalculate];
}

- (void) doCalculate {
	
	for (int i = 0; i < 5; i++) {
		int _fn = [(self.fstNumButtons)[i] getIntValue];
		int _op = [(self.opertnButtons)[i] getIntValue];
		int _sn = [(self.secNumButtons)[i] getIntValue];
		
		MyRorButton *btn = (self.rowResButtons)[i];
		int currentIntValue = [btn getIntValue];
		int newIntValue = (_fn != 0 && _op != -1 && _sn != 0) ? [self rrWfn:_fn op:_op sn:_sn] : 0;
		
		if (currentIntValue != newIntValue) {
			if (btn.dependingBtn != nil) {
				MyTxButton *txBtn = btn.dependingBtn;
				[txBtn setIntValue:0];
				txBtn.isRRButton = NO;
				txBtn.btnHeld = nil;
				txBtn.isUsed = NO;
			}
			
			[btn setTitleColorFlue:NO];
			btn.isUsed = NO;
			btn.dependingBtn = nil;
		}

		if (_fn == 0 && _sn == 0)
			[(self.opertnButtons)[i] setIntValue:-1];

		[btn setIntValue:newIntValue];
	}
	
	[self checkIntegrity];
}

- (void) doCalculateForAnimation {
	
	for (int i = 0; i < 5; i++) {
		int _fn = [(self.fstNumButtons)[i] getIntValue];
		int _op = [(self.opertnButtons)[i] getIntValue];
		int _sn = [(self.secNumButtons)[i] getIntValue];
		
		MyRorButton *btn = (self.rowResButtons)[i];
		int currentIntValue = [btn getIntValue];
		int newIntValue = (_fn != 0 && _op != -1 && _sn != 0) ? [self rrWfn:_fn op:_op sn:_sn] : 0;
		
		if (currentIntValue != newIntValue) {
			if (btn.dependingBtn != nil) {
				MyTxButton *txBtn = btn.dependingBtn;
				[txBtn setIntValue:0];
				txBtn.isRRButton = NO;
				txBtn.btnHeld = nil;
			}
			
			[btn setTitleColorFlue:NO];
			btn.dependingBtn = nil;
		}
		
		[btn setIntValue:newIntValue];
	}
}

- (int) rrWfn:(int) fn op:(int) op sn:(int) sn {
	if (op == 0) return fn + sn;
	if (op == 2) return fn * sn;
	
	// Substract
	if (op == 1)
		return (fn > sn)?(fn - sn):0;
	
	// Divide
	if (op == 3) {
		if (sn > 0 && fn >= sn && (fn % sn == 0))
			return fn/sn;
	}
	
	return 0;
}

- (void) updateTimer:(NSTimer *) timer {
	[self.timerLbl setText:[NSString stringWithFormat:@"%d", --timeLeft]];

	if (timeLeft <= 10) {
		[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(playCountdown:) userInfo:nil repeats:NO];
	}
	
	if (timeLeft == 1) {
		if ([[NSUserDefaults standardUserDefaults] boolForKey:ALERTONDISPLAY] == YES) {
			[self stopTimers];
		}
	}
}

- (void) checkResult: (NSTimer *) timer {
	
	NSMutableArray *inRanges = [[NSMutableArray alloc] init];
	BOOL found = NO, inRange = NO;
	int range; int foundIndex = -1;

	if (level <= 10) range = 10;
	else if (level <= 20) range = 8;
	else range = 5;
	
	for (int i = 0; i < [self.rowResButtons count]; i++) {
		int rr = [(self.rowResButtons)[i] getIntValue];

		if (rr == targetNr) {
			found = YES;
			foundIndex = i;
			break;
		}
		else if (abs(rr - targetNr) <= range) {
			inRange = YES;
			[inRanges addObject:@[@(abs(rr - targetNr)), @(i)]];
		}
	}
	
	if (found) {
		[self stopTimers];
		[(self.rowResButtons)[foundIndex] setBgImage:[UIImage imageNamed:BG_TX_RND_BTN]];
		[self endGameWithSuccess:YES];
		return;
	}
	
	[self.manualEndBtn setBgImage:inRange?[UIImage imageNamed:@"DragBarBtnOn.png"]:[UIImage imageNamed:@"DragBarBtnOff.png"]];
	
	if (timeLeft == 0) {
		[self stopTimers];

		if (inRange) {
			int closestIndex = -1, diff = range + 1;
			
			for (int i = 0; i < [inRanges count]; i++) {
				NSArray *values = inRanges[i];
				int indexDiff = [values[0] intValue];
				int indexRange = [values[1] intValue];
				
				if (indexDiff < diff) {
					closestIndex = indexRange;
					diff = indexDiff;
				}
			}
			
			[(self.rowResButtons)[closestIndex] setBgImage:[UIImage imageNamed:BG_TX_RND_BTN]];
			[self endingManually:diff];
		}
		else {
			[self endGameWithSuccess:NO];
		}
	}

}

- (void) checkIntegrity {

	// Bu array, rnd numberlarin isUsed = NO oldugu halde isUsed modunda olmasi
	// durumunu kontrol icin kullanilacak.
	NSMutableArray *usedRndNumbers = [[NSMutableArray alloc] init];
	NSMutableArray *usedRorNumbers = [[NSMutableArray alloc] init];

	for (int i = 0; i < 5; i++) {

		MyTxButton *fstBtn = (self.fstNumButtons)[i];
		MyTxButton *secBtn = (self.secNumButtons)[i];		

		if (fstBtn.isUsed) {
			if (fstBtn.isRRButton) {
				BOOL integrity = NO;
				for (int j = 0; j < i; j++) {
					MyRorButton *rrBtn = (self.rowResButtons)[j];
					if ([fstBtn getIntValue] == [rrBtn getIntValue]) {
						integrity = YES;
						break;
					}
				}

				if (integrity == NO) {
					[fstBtn setIntValue:0];
					[fstBtn setBgImage:self.txImage];
					fstBtn.isUsed = NO;
					fstBtn.isRRButton = NO;
					NSLog(@"RR INTEGRITY CHECK CAUGHT A BUG");
				}
				else {
					[usedRorNumbers addObject:@([fstBtn getIntValue])];
				}
			}
			else {
				[usedRndNumbers addObject:@([fstBtn getIntValue])];
			}
		}

		if (secBtn.isUsed) {
			if (secBtn.isRRButton) {
				BOOL integrity = NO;
				for (int j = 0; j < i; j++) {
					MyRorButton *rrBtn = (self.rowResButtons)[j];
					if ([secBtn getIntValue] == [rrBtn getIntValue]) {
						integrity = YES;
						break;
					}
				}

				if (integrity == NO) {
					[secBtn setIntValue:0];
					[secBtn setBgImage:self.txImage];
					secBtn.isUsed = NO;
					secBtn.isRRButton = NO;
					NSLog(@"RR INTEGRITY CHECK CAUGHT A BUG");
				}
				else {
					[usedRorNumbers addObject:@([secBtn getIntValue])];
				}
			}
			else {
				[usedRndNumbers addObject:@([secBtn getIntValue])];
			}
		}
	}

	for (int i = 0; i < 6; i++) {
		MyRndButton *rndBtn = (self.rndNumButtons)[i];

		if (rndBtn.isUsed) {
			NSNumber *rndValue = @([rndBtn getIntValue]);

			if ([usedRndNumbers indexOfObject:rndValue] != NSNotFound) {
				int index = [usedRndNumbers indexOfObject:rndValue];
				[usedRndNumbers removeObjectAtIndex:index];
			}
			else {
				rndBtn.isUsed = NO;
				[rndBtn setTitleColorFlue:NO];
				NSLog(@"RND INTEGRITY CHECK CAUGHT A BUG");
			}
		}
	}

	for (int i = 0; i < 5; i++) {
		MyRorButton *rorBtn = (self.rowResButtons)[i];
		
		if (rorBtn.isUsed) {
			NSNumber *rorValue = @([rorBtn getIntValue]);
			
			if ([usedRorNumbers indexOfObject:rorValue] != NSNotFound) {
				int index = [usedRorNumbers indexOfObject:rorValue];
				[usedRorNumbers removeObjectAtIndex:index];
			}
			else {
				rorBtn.isUsed = NO;
				[rorBtn setTitleColorFlue:NO];
				NSLog(@"ROR COLUMN INTEGRITY CHECK CAUGHT A BUG");
			}
		}
	}

}

- (void) endGameWithSuccess:(BOOL) success {
	
	[self setViewAlpha:0.3 duration:0.5];

	if (success) {
		insertScore = YES;
		
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(gameOverSuccess:) userInfo:nil repeats:NO];
		
		NSArray *points = [self calculatePoints:FULLPOINTS difference:0];
		
		int totalPoints = [points[0] intValue];
		int levelBonus = [points[1] intValue];
		int timeBonus = [points[2] intValue];
		
		score += totalPoints;
		[self.scoreLbl setText:[NSString stringWithFormat:@"%d", score]];
		[self updateHighScore];

		[Utils saveBool:YES forKey:IN_GAME];
		int lastLevel = level + 1;
		[Utils saveInt:lastLevel forKey:LAST_LEVEL];
		[Utils saveInt:score forKey:LAST_SCORE];

		if (level == 10) {
			int easyModeScore = [[NSUserDefaults standardUserDefaults] integerForKey:EASY_MODE];

			if (score > easyModeScore) {
				[Utils saveInt:score forKey:EASY_MODE];
			}
		}
		else if (level == 20) {
			int mediumModeScore = [[NSUserDefaults standardUserDefaults] integerForKey:MEDIUM_MODE];

			if (score > mediumModeScore) {
				[Utils saveInt:score forKey:MEDIUM_MODE];
			}
		}

		NSString *message = [NSString stringWithFormat:@"Right on target! You passed level %d. You earned %d points!", level, totalPoints];
		NSString *message2 = [NSString stringWithFormat:@"\n\nLevel Bonus: +%d\nTime Bonus: +%d", levelBonus, timeBonus];

		[self showAlertWithTitle:@"CONGRATULATIONS!" message:[message stringByAppendingString:message2]  cancelTitle:@"Next Level" otherTitles:nil];
	} 
	else {
		[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(gameOverFailed:) userInfo:nil repeats:NO];

		inGame = NO;
		[Utils saveBool:NO forKey:IN_GAME];
		[Utils saveInt:level forKey:LAST_LEVEL];
		[Utils saveInt:score forKey:LAST_SCORE];

		if (insertScore && score > 0)
			[MyDao insertScore:score withLevel:level];

		[self updateHighScore];
		// music player stop
		@try { [self.musicPlayer stop]; }
		@catch (NSException * e) {
			@try { [self.musicPlayer stop]; }
			@catch (NSException * e) { }
		}

		[self showAlertWithTitle:@"GAME OVER" 
						 message:@"Sorry, time is out. You have failed to reach the target number"
					 cancelTitle:@"Start a new game"
					 otherTitles:[NSMutableArray arrayWithObjects:@"See solution", @"Quit", nil]];
	} 
}

- (void) endingManually:(int) difference {
	insertScore = YES;
	
	[NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(gameOverSuccess:) userInfo:nil repeats:NO];
	
	NSArray *points = [self calculatePoints:NEXTLEVEL_ONLY difference:difference];
	
	int totalPoints = [points[0] intValue];
	int levelBonus = [points[1] intValue];
	int timeBonus = [points[2] intValue];
	int minusDiff = [points[3] intValue];
	
	score += totalPoints;
	[self.scoreLbl setText:[NSString stringWithFormat:@"%d", score]];
	[self updateHighScore];
	
	[Utils saveBool:YES forKey:IN_GAME];
	int lastLevel = level + 1;
	[Utils saveInt:lastLevel   forKey:LAST_LEVEL];
	[Utils saveInt:score forKey:LAST_SCORE];
	
	if (level == 10) {
		int easyModeScore = [[NSUserDefaults standardUserDefaults] integerForKey:EASY_MODE];
		
		if (score > easyModeScore) {
			[Utils saveInt:score forKey:EASY_MODE];
		}
	}
	else if (level == 20) {
		int mediumModeScore = [[NSUserDefaults standardUserDefaults] integerForKey:MEDIUM_MODE];
		
		if (score > mediumModeScore) {
			[Utils saveInt:score forKey:MEDIUM_MODE];
		}
	}

	NSString *message = [NSString stringWithFormat:@"You passed level %d. You earned %d points!", level, totalPoints];
	NSString *message2 = [NSString stringWithFormat:@"\n\nLevel Bonus: +%d\nTime Bonus: +%d\nPenalty: -%d", levelBonus, timeBonus, minusDiff];
	
	[self showAlertWithTitle:@"CONGRATULATIONS!" message:[message stringByAppendingString:message2] cancelTitle:@"Next level" 
					 otherTitles:[NSMutableArray arrayWithObjects:@"See solution", nil]];
}

- (NSArray *) calculatePoints: (NSString *)type difference:(int) difference {

	int point, kFulPoint, kNxtLvl, fromTime, kDiff;
	int secondsPassed = currentLevelTimeLeft - timeLeft;
	
	if (level <= 10) {
		kFulPoint = 25; kNxtLvl = 10; fromTime = 15; kDiff = 1;
	}
	else if (level <= 20) {
		kFulPoint = 50; kNxtLvl = 20; fromTime = 30;	kDiff = 2;
	}
	else {
		kFulPoint = 75; kNxtLvl = 30; fromTime = 45;	kDiff = 3;
	}

	point = ([type isEqualToString:FULLPOINTS]) ? kFulPoint : kNxtLvl;
	int levelBonus = point;
	int timeBonus;
	
	if (secondsPassed <= 30) {
		timeBonus = fromTime;
	}
	else {
		double speed = fromTime - ( (fromTime * secondsPassed) / currentLevelTimeLeft);
		timeBonus = floor(speed);
	}
	point += timeBonus;
	
	int minusDiff = (difference * kDiff);
	point -= minusDiff;
	
	return @[@(point), @(levelBonus), @(timeBonus), @(minusDiff)];
}

//////////////////////////////////////////////////////////////////////////////
////////////////////////////    DELEGATES   /////////////////////////////////
////////////////////////////////////////////////////////////////////////////

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self setViewAlpha:1.0 duration:0.5];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if ([[alertView title] isEqual: @"QUIT?"]) {
		[defaults setBool:NO forKey:ALERTONDISPLAY];
		[defaults synchronize];

		if (buttonIndex == alertView.cancelButtonIndex) {
			[defaults setBool:NO forKey:SAVED_GAME];
			[defaults synchronize];

			[self startTimers];
		}
		else if (buttonIndex == 1) {
			if (tempAnimIndex == -1 && goToNextLevel)
				level++;
			
			[defaults setBool:YES forKey:SAVED_GAME];
			[defaults setInteger:level forKey:SAVED_LEVEL];
			[defaults setInteger:score forKey:SAVED_SCORE];
			[defaults synchronize];
		
			[self exitHome];		
		}
		else {
			[defaults setBool:NO forKey:SAVED_GAME];
			[defaults synchronize];

			if (insertScore && score > 0)
				[MyDao insertScore:score withLevel:level];
			
			[self updateHighScore];
			[self exitHome];
		}
	}
	else if ([[alertView title] isEqual: @"ARE YOU SURE?"]) {
		[defaults setBool:NO forKey:ALERTONDISPLAY];
		[defaults synchronize];
		
		if (buttonIndex == alertView.cancelButtonIndex) {
			[defaults setBool:NO forKey:SAVED_GAME];
			[defaults synchronize];
			
			[self startTimers];
		}
		else {
			[defaults setBool:NO forKey:SAVED_GAME];
			[defaults synchronize];
			
			if (insertScore && score > 0)
				[MyDao insertScore:score withLevel:level];
			
			[self updateHighScore];
			[self exitHome];
		}
	}
	else if ([[alertView title] isEqual: @"RESUME GAME?"]) {

		[defaults setBool:NO forKey:SAVED_GAME];
		[defaults synchronize];

		if (buttonIndex == alertView.cancelButtonIndex) {
			[self chooseMode];
		}
		else {
			level = [defaults integerForKey:SAVED_LEVEL];
			score = [defaults integerForKey:SAVED_SCORE];

			[self startGame:YES isResume:YES];
		}
	}
	else if ([[alertView title] isEqual: @"RESUME INTERRUPTED GAME?"]) {

		[defaults setBool:NO forKey:INTERRUPTED];
		[defaults setBool:YES forKey:IN_GAME];
		[defaults synchronize];
		inGame = YES;

		if (buttonIndex == alertView.cancelButtonIndex) {
			[self chooseMode];
		}
		else {
			level = [defaults integerForKey:LAST_LEVEL];
			score = [defaults integerForKey:LAST_SCORE];
			
			[self startGame:YES isResume:YES];
		}
	}
	else if ([[alertView title] isEqual: @"CONGRATULATIONS!"]) {
		[defaults setInteger:score forKey:CURRENTSCORE];
		[defaults synchronize];
		
		if (buttonIndex == alertView.cancelButtonIndex) {
			[self startGameMusic];
			[self startGame:YES isResume:NO];
		}
		else {
			[self resetButtons];
			[self lockButtons];
			
			tempAnimIndex = 0;
			goToNextLevel = YES;
			
			for (int i = 0; i < 5; i++) { // Backgroundlari fix et, just in case
				[(self.fstNumButtons)[i] setBgImage:(i < 4) ? self.txImage : [UIImage imageNamed:BG_TX_BTN_LAST]];
				[(self.secNumButtons)[i] setBgImage:(i < 4) ? self.txImage : [UIImage imageNamed:BG_TX_BTN_LAST]];
			}

			@try { [self.musicPlayer pause]; }
			@catch (NSException * e) {
				@try { [self.musicPlayer pause]; }
				@catch (NSException * e) { }
			}
			
			[self animateSolution:nil finished:NO context:nil];
			[self startAnimMusic];
		}
	}
	else if  ([[alertView title] isEqual: @"GAME OVER"]) {
		if (buttonIndex == alertView.cancelButtonIndex) {
			[self chooseMode];
		}
		else if (buttonIndex == 1) {
			[self resetButtons];
			[self lockButtons];
			tempAnimIndex = 0;
			
			for (int i = 0; i < 5; i++) { // Backgroundlari fix et, just in case
				[(self.fstNumButtons)[i] setBgImage:(i < 4) ? self.txImage : [UIImage imageNamed:BG_TX_BTN_LAST]];
				[(self.secNumButtons)[i] setBgImage:(i < 4) ? self.txImage : [UIImage imageNamed:BG_TX_BTN_LAST]];
			}
			
			[self animateSolution:nil finished:NO context:nil];
			[self startAnimMusic];
		}
		else {
			[self exitHome];
		}
	}
	else if  ([[alertView title] isEqual: @"NEW GAME?"]) {
		
		[defaults setBool:NO forKey:ALERTONDISPLAY];
		[defaults synchronize];

		if (buttonIndex == 1) {
			[self stopTimers];
			[self resetButtons];
			
			if (insertScore && score > 0)
				[MyDao insertScore:score withLevel:level];
			
			[self updateHighScore];
			[self chooseMode];
		}
		else {
			[self startGameMusic];
			[self startTimers];
		}
	}
	else if  ([[alertView title] isEqual: @"NEW GAME!"] || [[alertView title] isEqual: @"NEW MODE!"]) {
		[self showProgressIndicator:@"Please Wait..."];
		[self performSelectorInBackground:@selector(populateFields) withObject:nil];
		[self hideProgressIndicator];
	}
	else if  ([[alertView title] isEqual: @"Choose mode to start"]) {
		if (buttonIndex == 0) {
			[self startNewGame];
		}
		else if (buttonIndex == 1) {
			showNewModeAlert = NO;
			level = 10;
			score = [defaults integerForKey:EASY_MODE];
			[self.scoreLbl setText:[NSString stringWithFormat:@"%d", score]];
			[self startGame:YES isResume:NO];
		}
		else if (buttonIndex == 2) {
			showNewModeAlert = NO;
			level = 20;
			score = [defaults integerForKey:MEDIUM_MODE];
			[self.scoreLbl setText:[NSString stringWithFormat:@"%d", score]];
			[self startGame:YES isResume:NO];
		}
	}
}

//////////////////////////////////////////////////////////////////////////////
////////////////////////////    SHORTCUTS   /////////////////////////////////
////////////////////////////////////////////////////////////////////////////
- (void) showAlertWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancel otherTitles:(NSArray *)others {
	[self setViewAlpha:0.2 duration:0.3];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title 
													message:message
												   delegate:self
										  cancelButtonTitle:cancel
										  otherButtonTitles:nil];
	[alert setBackgroundColor:[UIColor clearColor]];
	
	if (others != nil) {
		for (int i = 0; i < [others count]; i++) {
			[alert addButtonWithTitle:others[i]];			
		}
	}
	
	[alert show];
}

- (void) setViewAlpha:(CGFloat)alpha duration:(NSTimeInterval) duration {
	[UIView animateWithDuration:duration
					 animations:^{
						 [self.view setAlpha:alpha];
					 }];
}

- (void) updateHighScore {
	if (score > hiScore) {
		hiScore = score;
		[self.hiScoreLbl setText:[NSString stringWithFormat:@"%d", hiScore]];
		[Utils saveInt:hiScore forKey:HIGHSCORE];
		[Utils saveObj:[NSDate date]  forKey:HIGHSCORE_DATE];
	}
}

- (void) startGameMusic {
	
	if (music && [self.musicPlayer isPlaying] == NO) {
		[self.musicPlayer setNumberOfLoops:-1];
		[self.musicPlayer setVolume:0.8];
		
		@try { [self.musicPlayer play]; }
		@catch (NSException *e) {
			@try { [self.musicPlayer play]; }
			@catch (NSException *e) {	}
		}
	}
}

- (void) startAnimMusic {
	
	if (music && [self.animPlayer isPlaying] == NO) {
		NSString *animMusicPath = [[NSBundle mainBundle] pathForResource:@"Animation" ofType:@"caf"];

		self.animPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:animMusicPath] error:nil];
		[self.animPlayer setNumberOfLoops:-1];

		@try { [self.animPlayer play]; }
		@catch (NSException *e) {
			@try { [self.animPlayer play]; }
			@catch (NSException *e) {	}
		}
	}
}

- (void) playNewMode: (NSTimer *) timer {
	if (sound) {
		NSString *newModePath = [[NSBundle mainBundle] pathForResource:@"NewMode" ofType:@"caf"];
		self.nextModePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:newModePath] error:nil];
	
		@try {
			[self.nextModePlayer play];
		}
		@catch (NSException *e) {
			NSLog(@"%@", [e reason]);
		@try { [self.nextModePlayer play]; }
			@catch (NSException *e) {	}
		}
	}
}

- (void) playButtonMoved: (NSTimer *) timer {
	if (sound) {
		@try { [self.dragPlayer play]; }
		@catch (NSException *e) {
			@try { [self.dragPlayer play]; }
			@catch (NSException *e) {	}
		}
	}
}

- (void) gameOverSuccess: (NSTimer *) timer {
	if (sound) {
		
		@try { [self.gameOverSuccessPlayer play]; }
		@catch (NSException *e) {
			@try { [self.gameOverSuccessPlayer play]; }
			@catch (NSException *e) {	}
		}
	}
}

- (void) gameOverFailed: (NSTimer *) timer {
	if (sound) {
		@try { [self.gameOverFailPlayer play]; }
		@catch (NSException *e) {
			@try { [self.gameOverFailPlayer play]; }
			@catch (NSException *e) {	}
		}
	}
}

- (void) opPressed: (NSTimer *) timer {
	if (sound) {
		@try { [self.opPlayer play]; }
		@catch (NSException *e) {
			@try { [self.opPlayer play]; }
			@catch (NSException *e) {	}
		}
	}
}

- (void) playCountdown: (NSTimer *) timer {
	if (sound) {
		@try { [self.countdownPlayer play]; }
		@catch (NSException *e) {
			@try { [self.countdownPlayer play]; }
			@catch (NSException *e) {	}
		}
	}
}

- (void) startTimers {
	if ([self.countdown isValid] == NO)
		self.countdown = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
	
	if ([self.resultCheck isValid] == NO)
		self.resultCheck = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkResult:) userInfo:nil repeats:YES];
}

- (void) stopTimers {
	if ([self.countdown isValid])
		[self.countdown invalidate];

	if ([self.resultCheck isValid])
		[self.resultCheck invalidate];
}

- (void) touchTimers:(NSNotification *) notif {
	if ([self.countdown isValid]) {
		[self.countdown invalidate];
		[self.resultCheck invalidate];
	}
	else {
		[self startTimers];
	}
}

- (void) exitHome {
	// music player stop
	@try { [self.musicPlayer stop]; }
	@catch (NSException * e) {
		@try { [self.musicPlayer stop]; }
		@catch (NSException * e) { }
	}

	@try { [self.animPlayer stop]; }
	@catch (NSException * e) {
		@try { [self.animPlayer stop]; }
		@catch (NSException * e) { }
	}
	
	[self resetButtonArrays:self.rndNumButtons];
	[self resetButtonArrays:self.fstNumButtons];
	[self resetButtonArrays:self.secNumButtons];
	[self resetButtonArrays:self.opertnButtons];
	[self resetButtonArrays:self.rowResButtons];
	
	[self stopTimers];
	
	timer = 0;
	score = 0;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:MUSIC_NOTIF object:self];
	[self.navigationController popViewControllerAnimated:YES];
}

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

//////////////////////////////////////////////////////////////////////////////
////////////////////////////    SOLUTION   //////////////////////////////////
////////////////////////////////////////////////////////////////////////////

- (MyButton *) getButtonWithGroup:(NSString *)group index:(int) index {
	
	if ([group isEqualToString:@"rn1"]) {
		return (self.rndNumButtons)[index];
	}
	if ([group isEqualToString:@"rn2"]) {
		return (self.rndNumButtons)[index];
	}
	if ([group isEqualToString:@"rr"]) {
		return (self.rowResButtons)[index];
	}
	
	return nil;
}

- (void) animateSolution:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	UIImage *txRndBtn = [UIImage imageNamed:BG_TX_RND_BTN];

	if (tempAnimIndex > 0) {
		AlgLine *line = (self.solution)[tempAnimIndex-1];
		MyButton *btn = (self.opertnButtons)[tempAnimIndex-1];
		[btn setIntValue:line.op];

		MyTxButton *fstBtn = (self.fstNumButtons)[tempAnimIndex-1];
		MyTxButton *secBtn = (self.secNumButtons)[tempAnimIndex-1];	
		
		[fstBtn setIntValue:[self.tmp1 getIntValue]]; [fstBtn setBgImage:[line.fn isEqualToString:@"rr"] ? self.rrImage : txRndBtn];
		[secBtn setIntValue:[self.tmp2 getIntValue]]; [secBtn setBgImage:[line.sn isEqualToString:@"rr"] ? self.rrImage : txRndBtn];
		
		[self.tmp1.button removeFromSuperview];
		[self.tmp2.button removeFromSuperview];
		
		[self doCalculateForAnimation];
		[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(playButtonMoved:) userInfo:nil repeats:NO];
	}
	
	if (tempAnimIndex == [self.solution count]) {
		MyRorButton *rrBtn = (self.rowResButtons)[tempAnimIndex-1];
		[rrBtn setBgImage:self.rndNormal];
		
		tempAnimIndex = -1;
		
		if (goToNextLevel) {
			[self.startNewGameBtn setBackgroundImage:[UIImage imageNamed:@"NextGameBarBtn.png"] forState:UIControlStateNormal];
			[self.startNewGameBtn setBackgroundImage:[UIImage imageNamed:@"NextGameBarBtnHgh.png"] forState:UIControlStateHighlighted];
		}
		return;
	}
	
	if (tempAnimIndex < [self.solution count]) {
		AlgLine *line = (self.solution)[tempAnimIndex];
		
		MyButton *fstBtnToMove = [self getButtonWithGroup:line.fn index:line.fnIndex];
		MyButton *fstBtnMoveTo = (self.fstNumButtons)[tempAnimIndex];
		
		MyButton *secBtnToMove = [self getButtonWithGroup:line.sn index:line.snIndex];
		MyButton *secBtnMoveTo = (self.secNumButtons)[tempAnimIndex];

		
		UIImage *fstBtnImage; int fstBtnW; int fstBtnH; CGFloat x1; CGFloat y1;
		if ([self.rndNumButtons indexOfObject:fstBtnToMove] != NSNotFound) {
			if ([self.rndNumButtons indexOfObject:fstBtnToMove] < 4) {
				fstBtnImage = txRndBtn;
				fstBtnW = 80; fstBtnH = 43; x1 = 1.0; y1 = 1.0;
			}
			else {
				fstBtnImage = self.rndLong;
				fstBtnW = 160; fstBtnH = 52; x1 = 0.5; y1 = 0.8;
			}
		}
		else {
			fstBtnImage = self.rrImage;
			fstBtnW = 80; fstBtnH = 43; x1 = 1.0; y1 = 1.0;
		}
		
		UIImage *secBtnImage; int secBtnW; int secBtnH; CGFloat x2; CGFloat y2;
		if ([self.rndNumButtons indexOfObject:secBtnToMove] != NSNotFound) {
			if ([self.rndNumButtons indexOfObject:secBtnToMove] < 4) {
				secBtnImage = txRndBtn;
				secBtnW = 80; secBtnH = 43; x2 = 1.0; y2 = 1.0;
			}
			else {
				secBtnImage = self.rndLong;
				secBtnW = 160; secBtnH = 52; x2 = 0.5; y2 = 0.8;
			}
		}
		else {
			secBtnImage = self.rrImage;
			secBtnW = 80; secBtnH = 43; x2 = 1.0; y2 = 1.0;
		}

		UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(fstBtnToMove.button.center.x - (fstBtnW/2), fstBtnToMove.button.center.y - (fstBtnH/2), fstBtnW, fstBtnH)];
		self.tmp1 = [[MyButton alloc] initWithButton:btn1 value:[fstBtnToMove getIntValue] index:0];
		self.tmp1.button.titleLabel.font = [UIFont fontWithName:@"LithosPro-Black" size:28.0];
		[self.tmp1 setBgImage:fstBtnImage];
		[self.view addSubview:self.tmp1.button];
		[self.view bringSubviewToFront:self.tmp1.button]; 

		UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(secBtnToMove.button.center.x - (secBtnW/2), secBtnToMove.button.center.y - (secBtnH/2), secBtnW, secBtnH)];
		self.tmp2 = [[MyButton alloc] initWithButton:btn2 value:[secBtnToMove getIntValue] index:0];
		self.tmp2.button.titleLabel.font = [UIFont fontWithName:@"LithosPro-Black" size:28.0];
		[self.tmp2 setBgImage:secBtnImage];
		[self.view addSubview:self.tmp2.button];
		[self.view bringSubviewToFront:self.tmp2.button]; 
		
		[fstBtnToMove setTitleColorFlue:YES];
		[secBtnToMove setTitleColorFlue:YES];

		tempAnimIndex++;
		
		[UIView animateWithDuration:2.5
							  delay:0.6
							options:UIViewAnimationOptionTransitionNone
						 animations:^{
							 self.tmp1.button.center = fstBtnMoveTo.button.center;
							 self.tmp2.button.center = secBtnMoveTo.button.center;
							 
							 self.tmp1.button.transform = CGAffineTransformMakeScale(x1, y1);
							 self.tmp2.button.transform = CGAffineTransformMakeScale(x2, y2);
						 }
						 completion:^(BOOL finished) {
							 [self endAnimation];
						 }];
	}
}

- (void) endAnimation {
	UIImage *txRndBtn = [UIImage imageNamed:BG_TX_RND_BTN];
	
	AlgLine *line = (self.solution)[tempAnimIndex-1];
	MyButton *btn = (self.opertnButtons)[tempAnimIndex-1];
	[btn setIntValue:line.op];
	MyTxButton *fstBtn = (self.fstNumButtons)[tempAnimIndex-1];
	MyTxButton *secBtn = (self.secNumButtons)[tempAnimIndex-1];	

	[fstBtn setIntValue:[self.tmp1 getIntValue]]; [fstBtn setBgImage:[line.fn isEqualToString:@"rr"] ? self.rrImage : txRndBtn];
	[secBtn setIntValue:[self.tmp2 getIntValue]]; [secBtn setBgImage:[line.sn isEqualToString:@"rr"] ? self.rrImage : txRndBtn];
	
	[self.tmp1.button removeFromSuperview];
 	[self.tmp2.button removeFromSuperview];
	 
	[self doCalculateForAnimation];
	[NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(playButtonMoved:) userInfo:nil repeats:NO];
	
	if (tempAnimIndex == [self.solution count]) {
		MyRorButton *rrBtn = (self.rowResButtons)[tempAnimIndex-1];
		[rrBtn setBgImage:self.rndNormal];

		tempAnimIndex = -1;
		
		if (goToNextLevel) {
			[self.startNewGameBtn setBackgroundImage:[UIImage imageNamed:@"NextGameBarBtn.png"] forState:UIControlStateNormal];
			[self.startNewGameBtn setBackgroundImage:[UIImage imageNamed:@"NextGameBarBtnHgh.png"] forState:UIControlStateHighlighted];
		}
		return;
	}

	if (tempAnimIndex < [self.solution count]) {
		AlgLine *line = (self.solution)[tempAnimIndex];

		MyButton *fstBtnToMove = [self getButtonWithGroup:line.fn index:line.fnIndex];
		MyButton *fstBtnMoveTo = (self.fstNumButtons)[tempAnimIndex];

		MyButton *secBtnToMove = [self getButtonWithGroup:line.sn index:line.snIndex];
		MyButton *secBtnMoveTo = (self.secNumButtons)[tempAnimIndex];

		UIImage *fstBtnImage; int fstBtnW; int fstBtnH; CGFloat x1; CGFloat y1;
		if ([self.rndNumButtons indexOfObject:fstBtnToMove] != NSNotFound) {
			if ([self.rndNumButtons indexOfObject:fstBtnToMove] < 4) {
				fstBtnImage = txRndBtn;
				fstBtnW = 80; fstBtnH = 43; x1 = 1.0; y1 = 1.0;
			}
			else {
				fstBtnImage = self.rndLong;
				fstBtnW = 160; fstBtnH = 52; x1 = 0.5; y1 = 0.8;
			}
		}
		else {
			fstBtnImage = self.rrImage;
			fstBtnW = 80; fstBtnH = 43; x1 = 1.0; y1 = 1.0;
		}

		UIImage *secBtnImage; int secBtnW; int secBtnH; CGFloat x2; CGFloat y2;
		if ([self.rndNumButtons indexOfObject:secBtnToMove] != NSNotFound) {
			if ([self.rndNumButtons indexOfObject:secBtnToMove] < 4) {
				secBtnImage = txRndBtn;
				secBtnW = 80; secBtnH = 43; x2 = 1.0; y2 = 1.0;
			}
			else {
				secBtnImage = self.rndLong;
				secBtnW = 160; secBtnH = 52; x2 = 0.5; y2 = 0.8;
			}
		}
		else {
			secBtnImage = self.rrImage;
			secBtnW = 80; secBtnH = 43; x2 = 1.0; y2 = 1.0;
		}
		
		UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(fstBtnToMove.button.center.x - (fstBtnW/2), fstBtnToMove.button.center.y - (fstBtnH/2), fstBtnW, fstBtnH)];
		self.tmp1 = [[MyButton alloc] initWithButton:btn1 value:[fstBtnToMove getIntValue] index:0];
		self.tmp1.button.titleLabel.font = [UIFont fontWithName:@"LithosPro-Black" size:28.0];
		[self.tmp1 setBgImage:fstBtnImage];
		[self.view addSubview:self.tmp1.button];
		[self.view bringSubviewToFront:self.tmp1.button];
		
		UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(secBtnToMove.button.center.x - (secBtnW/2), secBtnToMove.button.center.y - (secBtnH/2), secBtnW, secBtnH)];
		self.tmp2 = [[MyButton alloc] initWithButton:btn2 value:[secBtnToMove getIntValue] index:0];
		self.tmp2.button.titleLabel.font = [UIFont fontWithName:@"LithosPro-Black" size:28.0];
		[self.tmp2 setBgImage:secBtnImage];
		[self.view addSubview:self.tmp2.button];
		[self.view bringSubviewToFront:self.tmp2.button]; 
		
		[fstBtnToMove setTitleColorFlue:YES];
		[secBtnToMove setTitleColorFlue:YES];
		
		tempAnimIndex++;

		[UIView animateWithDuration:2.5
							  delay:0.6
							options:UIViewAnimationOptionTransitionNone
						 animations:^{
							 self.tmp1.button.center = fstBtnMoveTo.button.center;
							 self.tmp2.button.center = secBtnMoveTo.button.center;
							 
							 self.tmp1.button.transform = CGAffineTransformMakeScale(x1, y1);
							 self.tmp2.button.transform = CGAffineTransformMakeScale(x2, y2);
						 }
						 completion:^(BOOL finished) {
							 [self endAnimation];
						 }];
	}
}

@end