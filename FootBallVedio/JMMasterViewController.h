//
//  JMMasterViewController.h
//  FootBallVedio
//
//  Created by wang animeng on 13-4-17.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JMDetailViewController;

@interface JMMasterViewController : UITableViewController

@property (strong, nonatomic) JMDetailViewController *detailViewController;

- (void)refreshSource:(id)sender;

@end
