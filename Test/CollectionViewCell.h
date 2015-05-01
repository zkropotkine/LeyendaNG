//
//  CollectionViewCell.h
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 4/17/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@end
