//
//  MatrixVC.h
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>
#import "MyButton.h"

@interface MatrixVC : UIViewController <UIAlertViewDelegate> {
	
	BOOL sound, music, insertScore, goToNextLevel, showNewModeAlert, inGame;
	int tempAnimIndex;
	int level, score, hiScore, timer, targetNr, timeLeft, currentLevelTimeLeft, timeNegator;
	CGPoint tempOrigLocation;
}

@property (nonatomic, strong) NSTimer *countdown, *resultCheck;

@property (nonatomic, strong) IBOutlet UIButton *rn1, *rn2, *rn3, *rn4, *rn5, *rn6;
@property (nonatomic, strong) IBOutlet UIButton *fn1, *fn2, *fn3, *fn4, *fn5;
@property (nonatomic, strong) IBOutlet UIButton *tx1, *tx2, *tx3, *tx4, *tx5;
@property (nonatomic, strong) IBOutlet UIButton *sn1, *sn2, *sn3, *sn4, *sn5;
@property (nonatomic, strong) IBOutlet UIButton *rr1, *rr2, *rr3, *rr4, *rr5;

@property (nonatomic, strong) IBOutlet UIButton *manualEndDragBtn;
@property (nonatomic, strong) IBOutlet UIButton *startNewGameBtn, *quitBtn;

@property (nonatomic, strong) IBOutlet UILabel *levelLbl, *scoreLbl, *hiScoreLbl, *timerLbl, *targetNrLbl;
@property (nonatomic, strong) UIImage *rndNormal, *rndLong, *rrImage, *txImage;

@property (nonatomic, strong) MyButton *touchedButton, *tempButton, *manualEndBtn, *tmp1, *tmp2;

@property (nonatomic, strong) NSMutableArray *rndNumButtons, *fstNumButtons, *opertnButtons, *secNumButtons, *rowResButtons;
@property (nonatomic, strong) NSArray *solution;

@property (nonatomic, strong) AVAudioPlayer *musicPlayer, *nextModePlayer, *dragPlayer, *opPlayer, *countdownPlayer, *animPlayer, *gameOverSuccessPlayer, *gameOverFailPlayer;


- (IBAction) startNewGame:(id)sender;
- (IBAction) goBackToHome:(id)sender;
- (IBAction) resetButtons:(id)sender;

- (void) updateTimer:(NSTimer *) timer;
- (void) checkResult:(NSTimer *) timer;

@end
