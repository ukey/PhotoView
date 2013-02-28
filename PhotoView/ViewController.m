//
//  ViewController.m
//  PhotoView
//
//  Created by Yuki Sato on 2013/02/27.
//  Copyright (c) 2013 Yuki Sato. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setTitle:[self.group valueForProperty:ALAssetsGroupPropertyName]];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    self.group = nil;
    
    [super viewDidUnload];
}

@end
