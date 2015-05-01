//
//  MyAnnonation.m
//  Leyenda
//
//  Created by Daniel Rodriguez on 1/13/13.
//  Copyright (c) 2013 Daniel Rodriguez. All rights reserved.
//

#import "MyAnnonation.h"

@implementation MyAnnonation

-(id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
title:(NSString *)paramTitle
subTitle:(NSString *)paramSubTitle{
    
    self = [super init];
    
    if (self != nil){
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubTitle;
    }
    
    return(self);
    
}
@end
