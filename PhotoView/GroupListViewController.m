//
//  GroupListViewController.m
//  PhotoView
//
//  Created by Yuki Sato on 2013/02/27.
//  Copyright (c) 2013 Yuki Sato. All rights reserved.
//

#import "GroupListViewController.h"
#import "ViewController.h"

@interface GroupListViewController ()

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) NSMutableArray *groups;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@implementation GroupListViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"アルバム"];
    
    if (!self.assetsLibrary)
    {
        self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
    if (!self.groups)
    {
        self.groups = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.groups removeAllObjects];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group)
            {
                [self.groups addObject:group];
            }
            else
            {
                [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        };
        
        void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            NSLog(@"assetGroupEnumberatorFailure %@", [error description]);
        };
        
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"photoList"])
    {
        ViewController *viewController = [segue destinationViewController];
        viewController.group = [self.groups objectAtIndex:self.selectedIndexPath.row];
    }
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ALAssetsGroup *group = [self.groups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]];
    [cell.imageView setImage:[UIImage imageWithCGImage:[group posterImage]]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.groups.count > indexPath.row)
    {
        self.selectedIndexPath = indexPath;
        [self performSegueWithIdentifier:@"photoList" sender:self];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.assetsLibrary = nil;
    self.groups = nil;
    self.selectedIndexPath = nil;
    
    [super viewDidUnload];
}

@end
