//
//  AlbumsViewController.m
//  PhotoView
//
//  Created by Yuki Sato on 2013/02/27.
//  Copyright (c) 2013 Yuki Sato. All rights reserved.
//

#import "AlbumsViewController.h"
#import "PhotoListViewController.h"
#import "AppDelegate.h"

@interface AlbumsViewController ()

@property (nonatomic, strong) NSMutableArray *groups;

@end

@implementation AlbumsViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.groups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Albums"];
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
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
        ALAssetsLibraryGroupsEnumerationResultsBlock cameraRollEnumerationResultsBlock = ^(ALAssetsGroup *group, BOOL *stop)
        {
            if (group)
            {
                [self.groups addObject:group];
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock albumsEnumerationResultsBlock = ^(ALAssetsGroup *group, BOOL *stop)
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
        
        ALAssetsLibraryAccessFailureBlock accessFailureBlock = ^(NSError *error)
        {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
            
            NSLog(@"AssetsLibraryAccessFailure %@", [error description]);
        };
        
        [appDelegate.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:cameraRollEnumerationResultsBlock failureBlock:accessFailureBlock];
        [appDelegate.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:albumsEnumerationResultsBlock failureBlock:accessFailureBlock];
    });
    
    [super viewWillAppear:animated];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"fromAlbums"])
    {
        PhotoListViewController *photoListviewController = [segue destinationViewController];
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        photoListviewController.group = [self.groups objectAtIndex:indexPath.row];
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)", [group valueForProperty:ALAssetsGroupPropertyName], [group numberOfAssets]];
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
        [self performSegueWithIdentifier:@"fromAlbums" sender:indexPath];
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

    if ([self.view window] == nil)
    {
        self.groups = nil;
        self.view = nil;
    }
}

@end
