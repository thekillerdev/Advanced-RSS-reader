//
//  DetailViewController.m
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import "DetailViewController.h"
#import "RSSItem.h"

@interface DetailViewController () <UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation DetailViewController

#pragma mark - Getters
-(UIWebView*)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

#pragma mark - Setters
-(void)setRssItem:(RSSItem*)rssItem
{
    if (_rssItem != rssItem)
    {
        _rssItem = rssItem;
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL: _rssItem.link]];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.rssItem.title;
    
    CGRect frame = self.view.bounds;
    self.webView.frame = frame;
    [self.view addSubview:self.webView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.webView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end