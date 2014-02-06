//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, strong, readonly) NSString *username;
@property (nonatomic, strong, readonly) NSString *handle;
@property (nonatomic, strong, readonly) NSString *usernamePlusStatus;
@property (nonatomic,weak)NSString *userphoto;
@property (nonatomic, strong, readonly) NSString *retweetedBy;
@property (nonatomic, readonly) NSString *retweetedCount;
@property (nonatomic, readonly) NSString *createdAt;
@property (nonatomic, readonly) NSString *favoritesCount;
@property (nonatomic, readonly) NSString *tweetId;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
