//
//  PhotoCollectionViewCell.m
//  PhotoView
//
//  Created by Yuki Sato on 2013/03/01.
//  Copyright (c) 2013 Yuki Sato. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, frame.size.width - 6, frame.size.height - 6)];
        // 枠をつけるためにimageViewのサイズを一回り小さくしておく
        
        // 可変サイズのセルに追従するようにautoresizingMaskを設定
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        self.backgroundColor = [UIColor colorWithRed:1.000 green:0.822 blue:0.390 alpha:1.000];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
