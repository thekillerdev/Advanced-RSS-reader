//
//  MasterViewController.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

//Controllers
#import "MasterViewController.h"
#import "DetailViewController.h"

//Views
#import "TableHeaderView.h"

//Other
#import "RSSLoader.h"
#import "RSSItem.h"

#define FONT_REFRESH_CONTROL [UIFont fontWithName:@"Helvetica" size:11.0]

@interface MasterViewController ()
@property (nonatomic, strong) NSArray *rssItems;
@property (nonatomic, strong) NSURL *feedURL;
@end

@implementation MasterViewController

#pragma mark - Getters
-(NSURL*)feedURL
{
    if (_feedURL == nil)
    {
        _feedURL = [NSURL URLWithString:@"http://feeds.feedburner.com/TouchCodeMagazine"];
    }
    return _feedURL;
}

#pragma mark - View Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Advanced RSS Reader";
    
    self.tableView.tableHeaderView = [[TableHeaderView alloc] initWithText:@"fetching rss feed"];
    
    [self setupRefreshControl];
    
    [self refreshFeed];
}

-(void)setupRefreshControl
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(refreshInvoked:forState:)
             forControlEvents:UIControlEventValueChanged];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Fetching: %@", self.feedURL]
                                                                     attributes:@{NSFontAttributeName:FONT_REFRESH_CONTROL}];
    
    self.refreshControl = refreshControl;
}

-(void)refreshInvoked:(id)sender forState:(UIControlState)state
{
    [self refreshFeed];
}

-(void)refreshFeed
{
    RSSLoader* rss = [[RSSLoader alloc] init];
    
    [rss fetchRssWithURL:self.feedURL
                complete:^(NSString *title, NSArray *results) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [(TableHeaderView*)self.tableView.tableHeaderView setText:title];
                        self.rssItems = results;
                        [self.tableView reloadData];
                        [self.refreshControl endRefreshing];
                    });
                    
                }];
}

#pragma mark - TableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rssItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSItem *object = self.rssItems[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                            forIndexPath:indexPath];
    cell.textLabel.attributedText = object.cellMessage;
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RSSItem *item = [self.rssItems objectAtIndex:indexPath.row];
    CGRect cellMessageRect = [item.cellMessage boundingRectWithSize:CGSizeMake(200,10000)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                            context:nil];
    return cellMessageRect.size.height;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_ID_DETAIL]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        RSSItem *object = self.rssItems[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
        
    }
}

@end
