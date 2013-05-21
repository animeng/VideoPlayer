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
        self.getAction.basicPath = @"LiveVideo/football";
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
    return [_objects count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *object = _objects[section];
    NSArray * contents = [object objectForKey:@"list"];
    return contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *object = _objects[indexPath.section];
    NSArray * contents = [object objectForKey:@"list"];
    NSDictionary * content = [contents objectAtIndex:indexPath.row];
    cell.textLabel.text = [content objectForKey:@"title"];
    cell.detailTextLabel.text = [content objectForKey:@"subtitle"];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    if (indexPath.row%2 == 1) {
        cell.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1];
    }
    else{
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *object = _objects[indexPath.section];
    NSArray * contents = [object objectForKey:@"list"];
    NSDictionary * content = [contents objectAtIndex:indexPath.row];
    self.detailViewController.detailItem = content;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary * object = _objects[section];
    return [object objectForKey:@"name"];
}

//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UILabel *bgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
//    NSDictionary * object = _objects[section];
//    bgView.text = [object objectForKey:@"name"];
//    bgView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//    return bgView;
//}

#pragma mark - rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
