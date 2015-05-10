//
//  BHPhoto.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BHPhoto : NSObject

@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, strong, readonly) UIImage *image;

+ (BHPhoto *)photoWithImageURL:(NSURL *)imageURL;
+ (BHPhoto *)photoWithUIImage:(UIImage *)image;


- (id)initWithImageURL:(NSURL *)imageURL;
- (id)initWithUIImage:(UIImage *)image;

@end
