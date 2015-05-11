//
//  CollectionViewCellModel.h
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 5/1/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface CollectionViewCellModel : NSObject
@property(strong, nonatomic) NSString *title;
@property(strong, nonatomic) NSString *textDescription;
@property(strong, nonatomic) NSString *photosDirectory;
@property(assign, nonatomic) CLLocationCoordinate2D location;
@property(assign, nonatomic) UIImage *image;

-(id)initWithDescription:(NSString *)descr title:(NSString *)title location:(CLLocationCoordinate2D)location photosDirectory: (NSString *) photosDirectory;

-(id)initWithTitle:(NSString *)title image:(UIImage *)image;

@end
