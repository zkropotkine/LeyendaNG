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
#import "PhotoVCViewController.h"

#define NUMBER_OF_IMAGES 15

#define HEADER_SIZE 100.0f
#define FOOTER_SIZE 100.0f

@interface ViewController () <NHBalancedFlowLayoutDelegate>

@property (nonatomic, strong) NSArray *images;
    @property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@end

@implementation ViewController


-(NSString*) photosDirectory {
    return [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Galeria/"] stringByAppendingPathComponent:self.galleryTitle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *patternImage = [UIImage imageNamed:@"concrete_wall"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];
    
    double currentTime = CACurrentMediaTime();
    NSLog(@"TIME1 %f", currentTime);

    

    NSArray * photosArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.photosDirectory error:nil];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSString * dir = self.photosDirectory;
    
    
    for (int i = 0; i < photosArray.count; i++)
    {
        NSString *imageName = [photosArray objectAtIndex : i];
        NSString *photoFilePath = [dir stringByAppendingPathComponent:imageName];

        [images addObject:[UIImage imageNamed:photoFilePath]];
    }

    currentTime = CACurrentMediaTime();
    NSLog(@"TIME2 %f", currentTime);
    
    _images = images;
    
    
    currentTime = CACurrentMediaTime();
    NSLog(@"TIME3 %f", currentTime);
    
    // TODO: Eliminate these, check if we can do so first.
    NHBalancedFlowLayout *layout = (NHBalancedFlowLayout *)self.collectionViewLayout;
    layout.headerReferenceSize = CGSizeMake(HEADER_SIZE, HEADER_SIZE);
    layout.footerReferenceSize = CGSizeMake(FOOTER_SIZE, FOOTER_SIZE);
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 5;
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
    
    // load photo images in the background
    __weak ViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        //UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [self.images objectAtIndex:indexPath.item];
            
            NSIndexPath *currentIndexPathForCell = [collectionView indexPathForCell:cell];
            
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:currentIndexPathForCell]) {
                cell.imageView.image = image;
            }
        });
    }];
    
    
    operation.queuePriority = (indexPath.item == 0) ?
    NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];
    
    
    return cell;
}

// TODO: Check if we might want to add a Footer and Header to the image gallery
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
    [self performSegueWithIdentifier:@"photoDetailSegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"photoDetailSegue"]) {
        NSIndexPath *selectedIndexPath = sender;
        UIImage *image = [self.images objectAtIndex:selectedIndexPath.item];
        
        PhotoVCViewController *destViewController = segue.destinationViewController;
        [destViewController configureWithImage:image];
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    NHBalancedFlowLayout *flowLayout = (id) (NHBalancedFlowLayout *)self.collectionViewLayout;
    [flowLayout invalidateLayout];
}

- (void)viewWillLayoutSubviews;
{
    
    
}

@end
