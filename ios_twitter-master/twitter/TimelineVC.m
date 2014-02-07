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
#import "TweetDetailViewController.h"

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSString *favoriteOrUnfavorite;
-(void)refreshView:(UIRefreshControl *)refresh;

- (void)onSignOutButton;
- (void)reload;


@end

@implementation TimelineVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(myTestNotificationReceived:)
                                                     name:@"myTestNotification"
                                                   object:nil];
        
        
        
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
    
    //Refresh Control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [refresh addTarget:self action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
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
    cell.delegate = self;
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    cell.username1.text = tweet.username;
    cell.text.text = tweet.text;
    cell.text.tag = indexPath.row;
    if (tweet.retweetedBy != nil) {
        NSString *retweetedText = [tweet.retweetedBy stringByAppendingString:@" retweeted"];
        cell.retweetedBy.text = retweetedText;
    }
    
    NSLog(@"tweet.favorited is %d", tweet.favorited);
    if (tweet.favorited) {
        [cell.starButton setImage:[UIImage imageNamed:@"twitter_icons_star_on.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.starButton setImage:[UIImage imageNamed:@"twitter_icons_star_off.png"] forState:UIControlStateNormal];
    }
    
    
    
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
    NSDate *createdDate = [dateFormatter dateFromString:tweet.createdAt];
    NSDate *now = [NSDate date];
    
    //    NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createdDate];
    //    int numberOfDays = secondsBetween / 86400;
    //    NSLog(@"secondsBetween is [%d]", secondsBetween);
    //
    
    //Retweeted by
    int retweetedCount = tweet.retweetedCount;
    
    if(retweetedCount > 0){
        cell.retweetedBy.text = tweet.retweetedBy;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Tweet *tweet = self.tweets[indexPath.row];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat width = screenRect.size.width;
    width -= 64;
    
    //GET SIZE OF RETWEET USERNAME
    UILabel *retLabel = [[UILabel alloc] init];
    //TODO add the retweeter field here (retweeted by so and so)
    NSString *retString = @"retweeter";
    [retLabel setAttributedText:[[NSAttributedString alloc] initWithString:retString]];
    CGRect retRect = [retLabel.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}
                                                 context:nil];
    CGFloat retUserHeight = retRect.size.height;
    
    
    // GET SIZE OF LABELS
    UILabel *label = [[UILabel alloc] init];
    NSString *labelString = tweet.username;
    
    [label setAttributedText:[[NSAttributedString alloc] initWithString:labelString]];
    CGRect labelRect = [label.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    CGFloat labelHeight = labelRect.size.height;
    
    
    //GET SIZE OF TEXTVIEW
    UITextView *textView = [[UITextView alloc] init];
    NSString *theText = tweet.text;
    [textView setAttributedText:[[NSAttributedString alloc] initWithString:theText]];
    
    CGRect textRect = [textView.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                                                  context:nil];
    CGFloat textHeight = textRect.size.height + 20;
    
    // GETSIZE OF ICONS
    CGFloat iconHeight = 20;
    
    //ADD ALL OF THE CONTROL HEIGHTS UP
    CGFloat h = retUserHeight + 10 + labelHeight + 10 + textHeight + 10 + iconHeight + 20;
    
    return h;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Tweet *tweet = self.tweets[indexPath.row];
    TweetDetailViewController *detailViewController = [[TweetDetailViewController alloc] initWithNibName:@"TweetDetailViewController" bundle:nil];
    
    detailViewController.username = tweet.username;
    detailViewController.userImageLink = tweet.userphoto;
    detailViewController.handle = tweet.handle;
    detailViewController.tweetText = tweet.text;
    detailViewController.createdAt = tweet.createdAt;
    detailViewController.favoritesCount = tweet.favoritesCount;
    detailViewController.retweetCount = tweet.retweetedCount;
    detailViewController.createdAt = tweet.createdAt;
    NSInteger val = [tweet.tweetId integerValue];
    detailViewController.onReplyStatusId = val;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
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
    NSDictionary *currentUsername = [currentUser valueOrNilForKeyPath:@"name"];
    NSDictionary *currentHandle = [currentUser valueOrNilForKeyPath:@"screen_name"];
    NSDictionary *currentImageLink = [currentUser valueOrNilForKeyPath:@"profile_image_url"];
    
    newTweet.userImageLink = (NSString *)currentImageLink;
    newTweet.username = (NSString *)currentUsername;
    newTweet.handle = (NSString *)currentHandle;
    
    [self.navigationController pushViewController:newTweet animated:YES];
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
//        NSLog(@"The whole response is [%@]", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

-(void)onReplyButton:(id)sender tweet:(Tweet *)tweet {
    TweetNewVC *newTweet = [[TweetNewVC alloc] init];
    
    User *currentUser = [User currentUser];
    NSDictionary *currentUsername = [currentUser valueOrNilForKeyPath:@"name"];
    NSDictionary *currentHandle = [currentUser valueOrNilForKeyPath:@"screen_name"];
    NSDictionary *currentImageLink = [currentUser valueOrNilForKeyPath:@"profile_image_url"];
    
    newTweet.userImageLink = (NSString *)currentImageLink;
    newTweet.username = (NSString *)currentUsername;
    newTweet.handle = (NSString *)currentHandle;
    
    //To do the reply: supply the in_reply_to_status_id parameter with the tweet ID you're replying to, and begin the tweet with the @username who authored the tweet being replied to.
    NSInteger val = [tweet.tweetId integerValue];
    newTweet.inReplyToStatusId = val;
    NSString *replyToUsername = [@"@" stringByAppendingString:tweet.username];
    newTweet.tweetToAdd = replyToUsername;
    
    [self.navigationController pushViewController:newTweet animated:YES];
    
}

-(void)onRetweetButton:(id)sender tweet:(Tweet *)tweet{
    
    [[TwitterClient instance] retweet:tweet.text inReplyToId:tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Pia, the unfortunate error is [%@]", error);
    }];
    
}

-(void)onFavoriteButton:(id)sender tweet:(Tweet *)tweet{
    
    NSLog(@"onFavoriteButton, tweet.favorited is %d",tweet.favorited);
    NSLog(@"onFavoriteButton, tweet.text is [%@]",tweet.text);

    UIButton *button = sender;

    
//    if(tweet.favorited == false){
    if(button.tag != 1){
        NSLog(@"!tweet.favorited");
        [[TwitterClient instance] favorite:tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Pia, the unfortunate error is [%@]", error);
        }];
            button.tag = 1;
        tweet.favorited = true;
        [sender setImage:[UIImage imageNamed:@"twitter_icons_star_on.png"] forState:UIControlStateNormal];
        NSLog(@"Now, within the favoriting the onFavoriteButton, the tweet.favorited value is %d", tweet.favorited);

    }
    else {
        NSLog(@"tweet.favorited is else");
        [[TwitterClient instance] unfavorite:tweet.tweetId success:^(AFHTTPRequestOperation *operation, id response) {
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Pia, the unfortunate error is [%@]", error);
        }];
        
        [sender setImage:[UIImage imageNamed:@"twitter_icons_star_off.png"] forState:UIControlStateNormal];
        button.tag = 0;
        tweet.favorited = false;
        NSLog(@"Now, within the unfavoriting the onFavoriteButton, the tweet.favorited value is %d", tweet.favorited);
    }
    
    NSLog(@"Now, leaving the onFavoriteButton, the tweet.favorited value is %d", tweet.favorited);
}

-(void)refreshView:(UIRefreshControl *)refresh {
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    // custom refresh logic would be placed here...
    [self reload];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    [refresh endRefreshing];
}

- (void) myTestNotificationReceived:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"myTestNotification"])
        NSLog (@"Notification is successfully received!");
}



//Make the tweet you just added show up here!
//- (void) viewWillAppear:(BOOL)animated {
//
////    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
////    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
//
//    NSLog(@"View Will Appear");
//
//    NSString *theTweetToAdd = [[NSUserDefaults standardUserDefaults] objectForKey:@"newTweet"];
//
//    if (theTweetToAdd !=nil ) {
//
////        [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
////            //NSLog(@"%@", response);
////            self.tweets = [Tweet tweetsWithArray:response];
////
////        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////            // Do nothing
////        }];
////
//        Tweet *newTweet = [[Tweet alloc] init];
//
//        NSLog(@"self.tweets.length is %d",[self.tweets count]);
//        [self.tweets insertObject:[newTweet initNewTweet:theTweetToAdd] atIndex:0];
//        NSLog(@"newTweet is %@",newTweet);
//        NSLog(@"newTweet.username is %@",newTweet.username);
//        NSLog(@"self.tweets.length is %d",[self.tweets count]);
//
//        [self.tableView reloadData];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"newTweet"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//
//
//    }

//    NSMutableDictionary *changedTweetFromDetailView = [[NSUserDefaults standardUserDefaults] objectForKey:@"buttonChanges"];
//
//    if (changedTweetFromDetailView != nil) {
//
//        //Get the inde of the cell to replace with this updated tweet from Detail view
//
//        Tweet *tweet = [[Tweet alloc] init];
//        Tweet *copyTweet = [[Tweet alloc] init];
//        copyTweet = [tweet initFromDictionary:changedTweetFromDetailView];
//        NSInteger cellIndex = [copyTweet.cellIndexString intValue];
//
//        [self.tweets insertObject:tweet atIndex:cellIndex];
//
//        [self.tableView reloadData];
//        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"buttonChanges"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }



//    return;

//}





@end
