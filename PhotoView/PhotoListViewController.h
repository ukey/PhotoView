//
//  PhotoListViewController.h
//  PhotoView
//
//  Created by Yuki Sato on 2013/03/01.
//  Copyright (c) 2013 Yuki Sato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface PhotoListViewController : UICollectionViewController

@property (nonatomic, strong) ALAssetsGroup *group;

@end
