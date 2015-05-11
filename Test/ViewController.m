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

@end

@implementation ViewController


-(NSString*) photosDirectory {
    NSLog(@"======= %@", self.galleryTitle);
    //return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Galeria"];
    //NSLog(@"===PATH=== %@", [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Galeria/"] stringByAppendingPathComponent:self.leyendaModel.title]);
    
    return [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Galeria/"] stringByAppendingPathComponent:self.galleryTitle];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
       /* NSMutableArray *images = [[NSMutableArray alloc] init];
        //for (int i = 1; i <= NUMBER_OF_IMAGES; i++) {
           // NSString *imageName = [NSString stringWithFormat:@"photo-%02d.png", i];
           // [images addObject:[UIImage imageNamed:imageName]];
        //}
        
        
        NSString * fullPhotosDirectory = [NSString stringWithFormat:@"%@/%@", self.photosDirectory, self.galleryTitle];
        
        NSArray * photosArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fullPhotosDirectory error:nil];
        
        for (int i = 1; i <= photosArray.count; i++) {
            NSString *imageName = [photosArray objectAtIndex : i];
            [images addObject:[UIImage imageNamed:imageName]];
        }
        
        NSLog(@"Files: %@", photosArray);
        
        _images = [photosArray copy];*/
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"Title: %@", self.galleryTitle);
    NSLog(@"Title2: %@", self.photosDirectory);
    
    //NSString * fullPhotosDirectory = [NSString stringWithFormat:@"%@/%@/", self.photosDirectory, self.galleryTitle];
    
    NSArray * photosArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.photosDirectory error:nil];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < photosArray.count; i++) {
        NSString *imageName = [photosArray objectAtIndex : i];
        NSString *photoFilePath = [[self photosDirectory] stringByAppendingPathComponent:imageName];
        UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
        
        [images addObject:image];
    }
    
    NSLog(@"Files: %@", photosArray);
    
    _images = [photosArray copy];
    
     NSLog(@"Files: %@", self.images);
    
    NHBalancedFlowLayout *layout = (NHBalancedFlowLayout *)self.collectionViewLayout;
    layout.headerReferenceSize = CGSizeMake(HEADER_SIZE, HEADER_SIZE);
    layout.footerReferenceSize = CGSizeMake(FOOTER_SIZE, FOOTER_SIZE);
}

#pragma mark - UICollectionViewFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"item: %ld", (long)indexPath.item);
    NSLog(@"row: %ld", (long)indexPath.row);

    
    UIImage *image = [self.images objectAtIndex:indexPath.item];
    
    NSLog(@"width = %f, height = %f", image.size.width, image.size.height);
    
    return [image size];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
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
    [self performSegueWithIdentifier:@"photoDetailSegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"photoDetailSegue"]) {
        NSIndexPath *selectedIndexPath = sender;
        //UIImage *image = [self.images objectAtIndex:selectedIndexPath.row];
        
        
        //UIImage *image = [UIImage decodedImageWithImage:[self.images objectAtIndex:selectedIndexPath.row]];
        
        

       
        
        NSString *photosDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Leyendas"];
        
        NSArray * photosArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:photosDir error:nil];
        
        NSString *photoName = [photosArray objectAtIndex:selectedIndexPath.item];
        
        NSString *photoFilePath = [photosDir stringByAppendingPathComponent:photoName];
        
        //UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
        
        PhotoVCViewController *destViewController = segue.destinationViewController;
        destViewController.path = photoFilePath;
    }
}




-(void) viewDidAppear:(BOOL)animated {
    //NSLog(@"SI");
    //self.navigationController.hidesBarsOnTap = false;
    //[self.tabBarController.tabBar setHidden:NO];
    //[self.parentViewController.tabBarController.tabBar setHidden:NO];
    
}

@end
