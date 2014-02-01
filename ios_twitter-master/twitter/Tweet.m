//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSString *)username {
    NSDictionary *userInfo = [self.data valueOrNilForKeyPath:@"user"];
    return [userInfo valueForKey:@"name"];
}

- (NSString *)handle {
    NSDictionary *userInfo = [self.data valueOrNilForKeyPath:@"user"];
    return [userInfo valueForKey:@"screen_name"];
}


- (NSString *)userphoto {
    NSDictionary *userInfo = [self.data valueOrNilForKeyPath:@"user"];
    return [userInfo valueForKey:@"profile_image_url"];
}

- (NSString *)retweetCount {
    return [self.data valueOrNilForKeyPath:@"retweet_count"];
}

- (NSString *)retweetedBy {
    NSDictionary *retweetedStatus = [self.data valueOrNilForKeyPath:@"retweeted_status"];
    return [retweetedStatus valueForKey:@"contributors"];

}


+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
