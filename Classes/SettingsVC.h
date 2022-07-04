//
//  SettingsVC.h
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface SettingsVC : UIViewController

@property (nonatomic, strong) IBOutlet UISwitch *menuMusicSwitch, *gameSoundSwitch, *bypassModesSwitch;
@property (nonatomic, strong) IBOutlet UISegmentedControl *gameMusicChoice;
@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UIButton *registerBtn;


- (IBAction) registerNickname:(id)sender;

- (IBAction) dismissSettings:(id)sender;

- (IBAction) menuMusicChanged:(id)sender;

- (IBAction) gameMusicChanged:(id)sender;

- (IBAction) gameSoundChanged:(id)sender;

- (IBAction) bypassModesChanged:(id)sender;

@end