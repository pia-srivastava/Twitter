//
//  TweetDetailViewController.m
//  
//
//  Created by Pia Srivastava on 2/2/14.
//
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TweetNewVC.h"


@interface TweetDetailViewController ()
- (void)onReplyButton;
- (void)onRetweetButton;
- (void)onFavoriteButton;

@end

@implementation TweetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"TweetDetailViewController" bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Tweet";
    
    //Reply to Tweet!
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reply" style:UIBarButtonItemStylePlain target:self action:@selector(onReplyButton)];

    [self.replyButton targetForAction:@selector(onReplyButton) withSender:Nil];
    [self.retweetButton targetForAction:@selector(onRetweetButton) withSender:Nil];
    [self.favoriteButton targetForAction:@selector(onFavoriteButton) withSender:Nil];
    
    self.usernameLabel.text = self.username;
    self.handleLabel.text = self.handle;
    self.usernameLabel.text = self.username;
    self.tweetTextView.text = self.tweetText;
    self.timestampLabel.text = self.createdAt;
    
    id temp = self.favoritesCount;
    NSString *tempString = [NSString stringWithFormat:@"%@", temp];
    self.favoritesCountLabel.text=tempString;
    
    id tempR = self.favoritesCount;
    NSString *tempStringR = [NSString stringWithFormat:@"%@", tempR];
    self.retweetCountLabel.text=tempStringR;
    
    [self.userImageView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.userImageLink]]
                            placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                                         self.userImageView.image = image;
                                         
                                     }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                         
                                     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onReplyButton{
    NSLog(@"TweetCell: just pressed reply button");
    TweetNewVC *newTweet = [[TweetNewVC alloc] init];
    
    User *currentUser = [User currentUser];
    NSDictionary *currentUsername = [currentUser valueOrNilForKeyPath:@"name"];
    NSDictionary *currentHandle = [currentUser valueOrNilForKeyPath:@"screen_name"];
    NSDictionary *currentImageLink = [currentUser valueOrNilForKeyPath:@"profile_image_url"];
    
    newTweet.userImageLink = (NSString *)currentImageLink;
    newTweet.username = (NSString *)currentUsername;
    newTweet.handle = (NSString *)currentHandle;
    
    //To do the reply: supply the in_reply_to_status_id parameter with the tweet ID you're replying to, and begin the tweet with the @username who authored the tweet being replied to.
    newTweet.inReplyToStatusId = self.onReplyStatusId;
    NSString *replyToUsername = [@"@" stringByAppendingString:self.username];
    newTweet.tweetToAdd = replyToUsername;
    
    [self.navigationController pushViewController:newTweet animated:YES];
}

- (void)onRetweetButton{
    NSLog(@"on reply");
}
- (void)onFavoriteButton{
    NSLog(@"on reply");
}

- (void) myMethod
{
    // All instances of myClassA will be notified
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"myTestNotification"
     object:self];
}

@end
