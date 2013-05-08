//
//  JMMasterViewController.m
//  FootBallVedio
//
//  Created by wang animeng on 13-4-17.
//  Copyright (c) 2013年 jam. All rights reserved.
//

#import "JMMasterViewController.h"
#import "JMBasicAction.h"
#import "JMDetailViewController.h"

@interface JMMasterViewController () {
    NSMutableArray *_objects;
}
@property (nonatomic,strong) JMBasicAction *getAction;
@end

@implementation JMMasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Master", @"Master");
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        _objects = [[NSMutableArray alloc] init];
        self.getAction = [[JMBasicAction alloc] init];
        self.getAction.basicPath = @"LiveVideo/video";
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshSource:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    [self.getAction requestResult:^(NSArray *result) {
        _objects = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        ;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)refreshSource:(id)sender
{
    [self.getAction requestResult:^(NSArray *result) {
        _objects = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        ;
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *object = _objects[indexPath.row];
    cell.textLabel.text = [object objectForKey:@"name"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *object = _objects[indexPath.row];
    self.detailViewController.detailItem = object;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
