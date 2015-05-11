//
//  CollectionViewCellModel.m
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 5/1/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import "CollectionViewCellModel.h"

@implementation CollectionViewCellModel

-(id)initWithDescription:(NSString *)descr title:(NSString *)title location:(CLLocationCoordinate2D)location photosDirectory: (NSString *) photosDirectory
{
    self = [super init];
    if (self)
    {
        self.textDescription = descr;
        self.title = title;
        self.location = location;
        self.photosDirectory = photosDirectory;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title image:(UIImage *)image {
    self = [super init];
    if (self)
    {
        self.image = image;
        self.title = title;
    }
    return self;
}
@end
