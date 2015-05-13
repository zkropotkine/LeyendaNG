//
//  TabBarController.h
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 4/30/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCellModel.h"

@interface TabBarController : UITabBarController <UITabBarControllerDelegate>
@property (strong, nonatomic) CollectionViewCellModel *model;
@property (strong, nonatomic) IBOutlet UINavigationItem *tabBarNavigationItem;
@property (strong, nonatomic, readonly) UISegmentedControl *segmentedControl;
@end
