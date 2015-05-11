//
//  ViewController.h
//  BalancedFlowLayoutDemo
//
//  Created by Niels de Hoog on 08-10-13.
//  Copyright (c) 2013 Niels de Hoog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UICollectionViewController <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate>
@property(strong, nonatomic) NSString *galleryTitle;
@property(strong, nonatomic) NSString *photosDirectory;

@end
