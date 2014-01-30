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
//@property (nonatomic, strong, readonly) NSString *userProfilePicture;
@property (nonatomic, strong, readonly) NSString *from_user;
@property (nonatomic, strong, readonly) NSString *created_at;



+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
