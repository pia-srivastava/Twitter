//
//  TimelineVC.h
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetCell.h"

@interface TimelineVC : UITableViewController <UITextViewDelegate, UITableViewDataSource, UIScrollViewDelegate,TweetCellDelegate>

//- (IBAction)onReplyButton:(id)sender;
-(void)onReplyButton:(id)sender tweet:(Tweet *)tweet ;
-(void)onRetweetButton:(id)sender tweet:(Tweet *)tweet;

@end
