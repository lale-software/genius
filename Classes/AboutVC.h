//
//  AboutVC.h
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

#import "ContactVC.h"
#import "OtherAppsVC.h"

@interface AboutVC : UIViewController <UIActionSheetDelegate>

@property (nonatomic, strong) ContactVC *cvc;
@property (nonatomic, strong) OtherAppsVC *oavc;

- (IBAction) dismissAbout:(id)sender;

- (IBAction) linkClicked:(id)sender;

- (IBAction) otherAppsClicked:(id)sender;

@end
