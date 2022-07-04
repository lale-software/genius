//
//  InstructionsVC.m
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

#import "InstructionsVC.h"

@interface InstructionsVC(Private)
- (void)loadScrollViewWithPage:(int) page;
@end

@implementation InstructionsVC

- (void) viewDidLoad {
	[super viewDidLoad];

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
	
	self.views = [[NSMutableArray alloc] init];
	[self.views addObject:self.introduction];
	[self.views addObject:self.rules];
	[self.views addObject:self.modes];
	[self.views addObject:self.howToPlay];
	[self.views addObject:self.haveFun];

	self.scrollView.pagingEnabled = YES;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 5, self.scrollView.frame.size.height);
	self.scrollView.showsHorizontalScrollIndicator = NO;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollsToTop = NO;
	self.scrollView.delegate = self;

	self.pageControl.numberOfPages = 5;
	self.pageControl.currentPage = 0;

	[self loadScrollViewWithPage:0];
	[self loadScrollViewWithPage:1];
}

////////////////////////////////////////////////////////////////////////////////////

- (IBAction) dismissInstr:(id)sender {
	[self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction) changePage:(id)sender {
	int page = self.pageControl.currentPage;
	// load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
	[self loadScrollViewWithPage:page - 1];
	[self loadScrollViewWithPage:page];
	[self loadScrollViewWithPage:page + 1];
	// update the scroll view to the appropriate page
	CGRect frame = self.scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	[self.scrollView scrollRectToVisible:frame animated:YES];
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
	pageControlUsed = YES;	
}

- (void) loadScrollViewWithPage:(int) page {
	if (page < 0) return;
	if (page >= 5) return;
	
	// replace the placeholder if necessary
	UITextView *view = (self.views)[page];
	
	// add the controller's view to the scroll view
	CGRect frame = self.scrollView.frame;
	frame.origin.x = frame.size.width * page;
	frame.origin.y = 0;
	view.frame = frame;
	[self.scrollView addSubview:view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlUsed = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (pageControlUsed) {
		return;
	}

	CGFloat pageWidth = self.scrollView.frame.size.width;
	int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	self.pageControl.currentPage = page;
	
	[self loadScrollViewWithPage:page - 1];
	[self loadScrollViewWithPage:page];
	[self loadScrollViewWithPage:page + 1];
}

@end
