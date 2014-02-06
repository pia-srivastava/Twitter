//
//  TweetDetailViewController.h
//  twitter
//
//  Created by Pia Srivastava on 2/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetDetailViewController : UIViewController

@property(nonatomic,weak) IBOutlet UIImageView *userImageView;
@property(nonatomic,weak) IBOutlet UILabel *usernameLabel;
@property(nonatomic,weak) IBOutlet UILabel *handleLabel;
@property(nonatomic,weak) IBOutlet UILabel *favoritesCountLabel;
@property(nonatomic,weak) IBOutlet UILabel *retweetCountLabel;
@property(nonatomic,weak) IBOutlet UILabel *timestampLabel;
@property(nonatomic,weak) IBOutlet UITextView *tweetTextView;
@property(nonatomic,weak) IBOutlet UIButton *replyButton;
@property(nonatomic,weak) IBOutlet UIButton *retweetButton;
@property(nonatomic,weak) IBOutlet UIButton *favoriteButton;

//For passing from previous screen
@property(nonatomic,weak) NSString *userImageLink;
@property(nonatomic,weak) NSString *username;
@property(nonatomic,weak) NSString *handle;
@property(nonatomic,weak) NSString *tweetText;
@property(nonatomic,weak) NSString *createdAt;
@property(nonatomic,weak) NSString *favoritesCount;
@property(nonatomic,weak) NSString *retweetCount;
@property int onReplyStatusId;

@end
