//
//  PhotoListViewController.m
//  PhotoView
//
//  Created by Yuki Sato on 2013/03/01.
//  Copyright (c) 2013 Yuki Sato. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoCollectionViewCell.h"

@interface PhotoListViewController ()

@property (nonatomic, strong) NSMutableArray *assets;

@end

@implementation PhotoListViewController

#pragma mark -
#pragma mark View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.navigationItem setTitle:[self.group valueForProperty:ALAssetsGroupPropertyName]];
    
    if (!self.assets)
    {
        self.assets = [[NSMutableArray alloc] init];
    }
    else
    {
        [self.assets removeAllObjects];
    }
    
    [self.group setAssetsFilter:[ALAssetsFilter allPhotos]];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop)
        {
            if (result)
            {
                [self.assets addObject:result];
            }
            else
            {
                [self.collectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
            }
        };
        
        [self.group enumerateAssetsUsingBlock:assetsEnumerationBlock];
    });
}

#pragma mark -
#pragma mark Collection view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    
    return cell;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    self.group = nil;
    self.assets = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

@end
