//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "TweetNewVC.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onSignOutButton;
- (void)reload;
- (void)onNewButton;

@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Home";
        
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //register TweetCell
    UINib *tweetNib = [UINib nibWithNibName:@"TweetCell" bundle:Nil];
    [self.tableView registerNib:tweetNib forCellReuseIdentifier:@"TweetCell"];
    
    //Pretty it up
    UIColor *twitterBlue = [UIColor colorWithRed:64/255.0f green:153.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:twitterBlue];
    
    //Sign Out
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];

    //New Tweet!
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"TweetCell";
    TweetCell *cell = (TweetCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.username1.text = tweet.username;
    cell.text.text = tweet.text;

    //User photo
    NSURL *userphotoLink = [NSURL URLWithString:tweet.userphoto];
    __weak UITableViewCell *weakCell = cell;
    [cell.userphoto setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:userphotoLink]
                          placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                       weakCell.imageView.image = image;
                                       
                                       //only required if no placeholder is set to force the imageview on the cell to be laid out to house the new image.
                                       //if(weakCell.imageView.frame.size.height==0 || weakCell.imageView.frame.size.width==0 ){
                                       [weakCell setNeedsLayout];
                                       //}
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                       NSLog(@"failure Block");
                                       NSLog(@"error is %@", error);
                                       
                                   }];
    

    //Screen name/handle
    NSString *ampersand = @"@";
    NSString *handlePlus = [ampersand stringByAppendingString:tweet.handle];
    cell.handle.text = handlePlus;
    
    //Retweeted by
    int retweetedCount = tweet.retweetedCount;
    NSLog(@"retweeted count is %i", retweetedCount);
    NSLog(@"retweetedBy is %@",  tweet.retweetedBy);
    
    if(retweetedCount > 0){
        NSLog(@"retweetedBy is %@", tweet.retweetedBy);
        cell.retweetedBy.text = tweet.retweetedBy;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    UITextView *textView = [[UITextView alloc] init];
    NSString *theText = tweet.text;
    [textView setAttributedText:[[NSAttributedString alloc] initWithString:theText]];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat width = screenRect.size.width;
    width -= 64;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    CGRect textRect = [textView.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil];
    
    CGFloat h = textRect.size.height + 80;
    
    return h;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSLog(@"heightForRowAtIndexPath!!!!");
//    
//    UITextView *textView = [[UITextView alloc] init];
//    NSString *theText = [self.toDoItems objectAtIndex:indexPath.row];
//    [textView setAttributedText:[[NSAttributedString alloc] initWithString:theText]];
//    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat width = screenRect.size.width;
//    width -= 64;
//    
//    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:14];
//    //    CGRect textRect = [theText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}context:nil];
//    
//    CGRect textRect = [textView.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font}context:nil];
//    
//    CGFloat h = textRect.size.height + 30;
//    
//    NSLog(@"returning %f", h);
//    return h;
//    
//}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)onNewButton {

    TweetNewVC *newTweet = [[TweetNewVC alloc] init];
    
    User *currentUser = [User currentUser];
    NSLog(@"currentUser is [%@]",currentUser);
    NSDictionary *currentUsername = [currentUser valueOrNilForKeyPath:@"name"];
    NSDictionary *currentHandle = [currentUser valueOrNilForKeyPath:@"screen_name"];
    NSDictionary *currentImageLink = [currentUser valueOrNilForKeyPath:@"profile_image_url"];
    NSLog(@"currentUsername is [%@]",currentUsername);
    NSLog(@"currentHandle is [%@]",currentHandle);
    NSLog(@"currentImageLink is [%@]",currentImageLink);
    
    newTweet.userImageLink = (NSString *)currentImageLink;
    newTweet.username = (NSString *)currentUsername;
    newTweet.handle = (NSString *)currentHandle;
    
    [self.navigationController pushViewController:newTweet animated:YES];
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        //NSLog(@"The whole response is [%@]", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

@end
