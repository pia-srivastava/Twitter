//
//  TweetNewVC.m
//  twitter
//
//  Created by Pia Srivastava on 2/1/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "TweetNewVC.h"
#import "UIImageView+AFNetworking.h"

@interface TweetNewVC ()

- (void)onTweetButton:(NSString *)tweet;

@end

@implementation TweetNewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *twitterGrey = [UIColor colorWithRed:245/255.0f green:248.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    UIColor *twitterBlue = [UIColor colorWithRed:64/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setTintColor:twitterBlue];
    [self.navigationController.navigationBar setBarTintColor:twitterGrey];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(onTweetButton:)];
    
    UINib *editableNib = [UINib nibWithNibName:@"EditableCell" bundle:nil];
    [self.tableView registerNib:editableNib forCellReuseIdentifier:@"EditableCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onTweetButton:(NSString *)tweet {
    
    NSString *theTweetToAdd = [[NSUserDefaults standardUserDefaults] objectForKey:@"tweetToAdd"];
    NSLog(@"We are now going to add this tweet [%@]", theTweetToAdd);
    
    [[TwitterClient instance] postATweet:theTweetToAdd];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"EditableCell";
    EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Name
    cell.name.text = self.username;
    
    //Handle
    cell.handle.text = self.handle;
 
    //User photo
    NSURL *userphotoLink = [NSURL URLWithString:self.userImageLink];
    __weak UITableViewCell *weakCell = cell;
    [cell.imageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:userphotoLink]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                       weakCell.imageView.image = image;
                                       NSLog(@"success Block");
                                       
                                       //only required if no placeholder is set to force the imageview on the cell to be laid out to house the new image.
                                       //if(weakCell.imageView.frame.size.height==0 || weakCell.imageView.frame.size.width==0 ){
                                       [weakCell setNeedsLayout];
                                       //}
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                       NSLog(@"failure Block");
                                       NSLog(@"error is %@", error);
                                       
                                   }];
    
    NSString *newTweet = self.tweetToAdd;
    cell.tweetToAdd.text = newTweet;

    [cell.tweetToAdd becomeFirstResponder];
    cell.tweetToAdd.delegate = self;

    NSLog(@"cellForRowAtIndexPath, self.tweetToAdd is %@", self.tweetToAdd);

     return cell;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    NSLog(@"shouldChangeText");
    NSString *text1 = [textView.text stringByReplacingCharactersInRange:range withString:text];
    //this is where i would put in validation if I wouldn't want the user to type in certain things
    
   	self.tweetToAdd = text1;
    [[NSUserDefaults standardUserDefaults] setObject:self.tweetToAdd forKey:@"tweetToAdd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    [self.tableView reloadData];
    
    NSLog(@"shouldChangeText, self.tweetToAdd is %@", self.tweetToAdd);
    
    return YES;
}


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	return YES;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"heightForRowAtIndexPath!!!!");
//    Tweet *tweet = self.tweets[indexPath.row];
//    
//    UITextView *textView = [[UITextView alloc] init];
//    NSString *theText = tweet.text;
//    [textView setAttributedText:[[NSAttributedString alloc] initWithString:theText]];
//    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat width = screenRect.size.width;
//    width -= 64;
//    
//    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14];
//    CGRect textRect = [textView.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil];
//    
//    CGFloat h = textRect.size.height + 80;
//
//    NSLog(@"returning %f", h);
//    CGFloat h = [[UIScreen mainScreen]bounds].size.height;
    CGFloat h = 200;
    return h;
    
}



@end
