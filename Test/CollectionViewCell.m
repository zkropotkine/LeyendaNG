//
//  CollectionViewCell.m
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 4/17/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) awakeFromNib {
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
    
    [super awakeFromNib];
}
@end
