//
//  DetailViewController.h
//  ARSSReader
//
//  Created by Marin Todorov on 29/10/2012.
//

#import <UIKit/UIKit.h>

#define SEGUE_ID_DETAIL @"showDetail"

@class RSSItem;

@interface DetailViewController : UIViewController
@property (strong, nonatomic) RSSItem *rssItem;
@end
