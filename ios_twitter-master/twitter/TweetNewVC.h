//
//  TweetNewVC.h
//  twitter
//
//  Created by Pia Srivastava on 2/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"
#import "EditableCell.h"

@interface TweetNewVC : UITableViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet EditableCell *editableCell;
@property(nonatomic,weak) IBOutlet UIImageView *userImage;

//For passing from previous screen
@property(nonatomic,weak) NSString *userImageLink;
@property(nonatomic,weak) NSString *username;
@property(nonatomic,weak) NSString *handle;
@property(nonatomic,weak) NSString *tweetToAdd;



@end
