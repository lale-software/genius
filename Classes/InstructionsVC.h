//
//  InstructionsVC.h
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

@interface InstructionsVC : UIViewController <UIScrollViewDelegate> {
   BOOL pageControlUsed;
}

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *views;

@property (nonatomic, strong) IBOutlet UIView *introduction;
@property (nonatomic, strong) IBOutlet UIView *howToPlay;
@property (nonatomic, strong) IBOutlet UIView *modes;
@property (nonatomic, strong) IBOutlet UIView *rules;
@property (nonatomic, strong) IBOutlet UIView *haveFun;

- (IBAction) dismissInstr:(id)sender;
- (IBAction) changePage:(id)sender;

@end
