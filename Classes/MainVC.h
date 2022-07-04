//
//  RootViewController.h
//  The Matrix
//
//  Created by Metehan Karabiber on 11/20/08.
//  Copyright lale-software.com 2008. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>

@interface MainVC : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate> {
	BOOL music; BOOL sound;
}

@property (nonatomic, strong) AVAudioPlayer *player;

- (IBAction) loadInstructionsView:(id)sender;
- (IBAction) loadAboutView:(id)sender;
- (IBAction) loadContactView:(id)sender;
- (IBAction) loadSettingsView:(id)sender;

- (IBAction) loadTrainingView:(id)sender;
- (IBAction) loadMatrixView:(id)sender;
- (IBAction) loadScoreboardView:(id)sender;

- (void) setViewAlpha:(CGFloat)alpha duration:(NSTimeInterval) duration;

@end
