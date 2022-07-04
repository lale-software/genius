//
//  ContactVC.h
//  The Matrix
//
//  Created by Metehan Karabiber on 4/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

@interface ContactVC : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *name, *email, *message;
@property (nonatomic, strong) CBProgressView *progressView;

@property (nonatomic, strong) NSMutableData *strReceivedData;
@property (nonatomic, strong) NSURLConnection *strConnection;

@property (nonatomic, strong) IBOutlet UIButton *doneBtn, *cancelBtn, *txtViewDoneBtn;

@property (nonatomic, strong) IBOutlet UITextField *txtField1, *txtField2;

- (IBAction) dismissContact:(id) sender;
- (IBAction) sendEmail:(id) sender;
- (IBAction) cancelClicked:(id) sender;
- (IBAction) doneClicked:(id) sender;

@end
