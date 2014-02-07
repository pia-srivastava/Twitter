//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *handle;
@property (nonatomic, strong) NSString *usernamePlusStatus;
@property (nonatomic,weak)NSString *userphoto;
@property (nonatomic, strong) NSString *retweetedBy;
@property (nonatomic) NSString *retweetedCount;
@property (nonatomic) NSString *createdAt;
@property (nonatomic) NSString *favoritesCount;
@property (nonatomic) NSString *tweetId;
@property (nonatomic) bool favorited;
@property (nonatomic) bool retweeted;


+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;
- (id) initNewTweet:(NSString*) tweetText;

@end
