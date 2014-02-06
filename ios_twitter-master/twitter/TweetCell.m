//
//  TweetCell.m
//  twitter
//
//  Created by Timothy Lee on 8/6/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetCell.h"
#import "TweetNewVC.h"
#import "TimelineVC.h"

@implementation TweetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onReplyButton:(id)sender {
      NSLog(@"TweetCell: just pressed reply button");
    
    [self.delegate onReplyButton:sender tweet:self.tweet];
}

- (IBAction)onRetweetButton:(id)sender {
    [self.delegate onRetweetButton:sender tweet:self.tweet];
}


//
//- (IBAction)onRetweetButton:(id)sender {
//    NSLog(@"just pressed retweet button");
//}
//
//- (IBAction)onFavoriteButton:(id)sender {
//    NSLog(@"just pressed favorite button");
//}

@end
