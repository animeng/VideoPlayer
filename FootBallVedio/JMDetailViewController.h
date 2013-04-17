//
//  JMDetailViewController.h
//  FootBallVedio
//
//  Created by wang animeng on 13-4-17.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMDetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
