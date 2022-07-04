//
//  ScoreboardVC.h
//  The Matrix
//
//  Created by Metehan Karabiber on 11/22/08.
//  Copyright 2008 lale-software.com. All rights reserved.
//

@interface ScoreboardVC : UIViewController 

@property (nonatomic, strong) IBOutlet UILabel *rank, *usr, *date, *point;
@property (nonatomic, strong) IBOutlet UITableView *tv;

- (IBAction) done:(id) sender;

@end
