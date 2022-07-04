//
//  TrainingVC.h
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

@class MyButton;
#import <AVFoundation/AVAudioPlayer.h>

@interface TrainingVC : UIViewController <UIAlertViewDelegate, UIAccelerometerDelegate> {
	BOOL animating;
}

@property (nonatomic, strong) IBOutlet UIButton *rn1, *rn2, *rn3, *rn4, *rn5, *rn6;
@property (nonatomic, strong) IBOutlet UIButton *fn1, *fn2, *fn3, *fn4, *fn5;
@property (nonatomic, strong) IBOutlet UIButton *tx1, *tx2, *tx3, *tx4, *tx5;
@property (nonatomic, strong) IBOutlet UIButton *sn1, *sn2, *sn3, *sn4, *sn5;
@property (nonatomic, strong) IBOutlet UIButton *rr1, *rr2, *rr3, *rr4, *rr5;
@property (nonatomic, strong) IBOutlet UIButton *manualEndDragBtn;

@property (nonatomic, strong) IBOutlet UIButton *startNewGameBtn, *quitBtn;

@property (nonatomic, strong) IBOutlet UILabel *level, *score, *hiScore, *timer, *targetNr;
@property (nonatomic, strong) UIImage *rndNormal, *rndLong, *rrImage, *txImage;
@property (nonatomic, strong) UIImageView *barHgh;

@property (nonatomic, strong) NSMutableArray *rndNumButtons, *fstNumButtons, *opertnButtons, *secNumButtons, *rowResButtons;

@property (nonatomic, strong) MyButton *tempButton1, *tempButton2;

@property (nonatomic, strong) AVAudioPlayer *demoPlayer;

@end
