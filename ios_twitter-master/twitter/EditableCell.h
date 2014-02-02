//
//  EditableCell.h
//  ToDo
//
//  Created by Anish Srivastava on 1/22/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *tweetToAdd;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *handle;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@end
