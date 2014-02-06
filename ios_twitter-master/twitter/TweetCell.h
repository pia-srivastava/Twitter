//
//  TweetCell.h
//  twitter
//
//  Created by Timothy Lee on 8/6/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TweetCellDelegate
-(void)onReplyButton:(id)sender tweet:(Tweet *)tweet;
-(void)onRetweetButton:(id)sender tweet:(Tweet *)tweet;

@end

@interface TweetCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *text;
@property (weak, nonatomic) IBOutlet UILabel *username1;
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (weak, nonatomic) IBOutlet UILabel *retweetedBy;
@property (weak, nonatomic) IBOutlet UIImageView *userphoto;
@property (weak, nonatomic) IBOutlet UILabel *hoursSinceTweeted;

@property (weak, nonatomic) Tweet *tweet;
@property (weak, nonatomic) id<TweetCellDelegate>delegate;

- (IBAction)onReplyButton:(id)sender;
- (IBAction)onRetweetButton:(id)sender;

@end
