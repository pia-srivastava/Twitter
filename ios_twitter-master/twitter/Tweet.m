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
    NSDictionary *user = [retweetedStatus valueOrNilForKeyPath:@"user"];
    return [user valueForKey:@"screen_name"];
}

- (NSString *)createdAt {
    return [self.data valueOrNilForKeyPath:@"created_at"];
}

- (NSString *)favoritesCount {
    NSDictionary *userInfo = [self.data valueOrNilForKeyPath:@"user"];
    return [userInfo valueForKey:@"favourites_count"];
}

- (NSString *)tweetId {
    return [self.data valueOrNilForKeyPath:@"id_str"];}

-(bool)favorited{
    NSString *favoritedRaw = [self.data valueOrNilForKeyPath:@"favorited"];
    NSLog(@"favorited in tweet.m is %@", favoritedRaw);
  	NSString *tempString = [NSString stringWithFormat:@"%@", favoritedRaw];

    if([tempString isEqualToString:@"0"]){
        return NO;
    }
    else{
        return YES;
    }
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}


- (id) initNewTweet:(NSString*) tweetText
{
    self = [super init];
    if (self ) {
        //Tweet *newTweet = [[Tweet alloc] init];
        User *currentUser = [User currentUser];
        
        self.text = tweetText;
        self.userphoto = [currentUser objectForKey:@"profile_image_url"];
        self.retweetedBy = [currentUser valueOrNilForKeyPath:@""];
        self.username = [currentUser valueOrNilForKeyPath:@"name"];
        self.handle= [currentUser valueOrNilForKeyPath:@"screen_name"];
        
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        [dateFormatter2 setDateFormat:@"MM/dd/yy, HH:mm a"];
        NSString *formattedDateString = [dateFormatter2 stringFromDate:currentDate];
        
        //        self.dateTime = formattedDateString;
        
        
        //        self.retweete=@"0";
        //        self.favoritesNumberString = @"0";
        //        self.starButtonSelected = NO;
        //        self.retweetButtonSelected = NO;
        
        
    }
    return self;
}
@end
