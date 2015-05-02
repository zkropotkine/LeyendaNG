//
//  FirstViewController.m
//  Test
//
//  Created by Daniel Rodriguez on 4/17/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import "CollectionDetailVC.h"

@interface CollectionDetailVC ()

@end

@implementation CollectionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        /* Reorganize views, or move child view controllers */
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        /* Do any cleanup, if necessary */
    }];
    
    
    [self.detailDescription scrollRangeToVisible:NSMakeRange(0, 0)];
}

@end
