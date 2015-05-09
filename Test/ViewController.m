//
//  ViewController.m
//  BalancedFlowLayoutDemo
//
//  Created by Niels de Hoog on 08-10-13.
//  Copyright (c) 2013 Niels de Hoog. All rights reserved.
//

#import "ViewController.h"
#import "ImageCell.h"
#import "NHLinearPartition.h"
#import "UIImage+Decompression.h"
#import "NHBalancedFlowLayout.h"

#define NUMBER_OF_IMAGES 15

#define HEADER_SIZE 100.0f
#define FOOTER_SIZE 100.0f

@interface ViewController () <NHBalancedFlowLayoutDelegate>

@property (nonatomic, strong) NSArray *images;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        for (int i = 1; i <= NUMBER_OF_IMAGES; i++) {
            NSString *imageName = [NSString stringWithFormat:@"photo-%02d.png", i];
            [images addObject:[UIImage imageNamed:imageName]];
        }
        _images = [images copy];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NHBalancedFlowLayout *layout = (NHBalancedFlowLayout *)self.collectionViewLayout;
    layout.headerReferenceSize = CGSizeMake(HEADER_SIZE, HEADER_SIZE);
    layout.footerReferenceSize = CGSizeMake(FOOTER_SIZE, FOOTER_SIZE);
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.images objectAtIndex:indexPath.item] size];
}

#pragma mark - UICollectionView data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    ImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    cell.imageView.image = nil;

    /**
     * Decompress image on background thread before displaying it to prevent lag
     */
    NSInteger rowIndex = indexPath.row;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage decodedImageWithImage:[self.images objectAtIndex:indexPath.item]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *currentIndexPathForCell = [collectionView indexPathForCell:cell];
            if (currentIndexPathForCell.row == rowIndex) {
                cell.imageView.image = image;
            }
        });
    });
    
    return cell;
}

/*- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    }
    
    return view;
}*/

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Entro aqui %@", indexPath);
    [self performSegueWithIdentifier:@"photoDetailSegue" sender:indexPath];
}


-(void) viewDidAppear:(BOOL)animated {
    //NSLog(@"SI");
    //self.navigationController.hidesBarsOnTap = false;
    //[self.tabBarController.tabBar setHidden:NO];
    //[self.parentViewController.tabBarController.tabBar setHidden:NO];
    
}

@end
