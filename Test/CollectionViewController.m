//
//  CollectionViewController.m
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 4/17/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionDetailVC.h"
#import "CollectionViewCell.h"
#import "CollectionViewCellModel.h"
#import "Displaying_Pins_on_a_Map_ViewViewController.h"
#import "TabBarController.h"


#import "BHAlbumTitleReusableView.h"
#import "BHPhotoAlbumLayout.h"
#import "BHAlbumPhotoCell.h"
#import "BHAlbum.h"
#import "BHPhoto.h"
#import "BHAlbumTitleReusableView.h"
#import "UIImage+Decompression.h"

static NSString * const AlbumTitleIdentifier = @"AlbumTitle";
static NSString * const PhotoCellIdentifier = @"PhotoCell";


@interface CollectionViewController ()

    @property (strong, nonatomic) NSArray *photosList;
    @property (strong, nonatomic) NSMutableDictionary *photosCache;
    @property (strong, nonatomic) NSString *photosDir;
    @property (nonatomic, strong) NSMutableArray *albums;
    @property (weak, nonatomic) IBOutlet BHPhotoAlbumLayout *photoAlbumLayout;
    @property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@end

@implementation CollectionViewController

-(NSString*) photosDirectory {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Leyendas"];
}


static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger photoIndex = 0;

    double currentTime = CACurrentMediaTime();
    NSLog(@"TIME1 %f", currentTime);
    UIImage *patternImage = [UIImage imageNamed:@"concrete_wall"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];

    //NSLog(@"Title == %@", self.navigationItem.title);
    //NSLog(@"Title == %d", [self.navigationItem.title isEqualToString:@"Leyendas"]);
    
    if ([self.navigationItem.title isEqualToString:@"Leyendas"]) {
        self.photosDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Leyendas/Small"];
    } else {
        self.photosDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Lugares/Small"];
    }
    //NSLog(@"%@", self.photosDir);
    
    
    NSArray * photosArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.photosDir error:nil];
    //NSLog(@"%@", photosArray);
    self.photosCache = [NSMutableDictionary dictionary];
    self.photosList = nil;
    //NSLog(@"THIS: %@", self.photosCache);

    
    self.albums = [NSMutableArray array];
    
    //NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
    

    for (NSInteger a = 0; a < photosArray.count; a++)
    {
         NSString *photoName = [photosArray objectAtIndex:a];
         NSString *photoNameSimple = [[photoName componentsSeparatedByString:@"."] objectAtIndex:0];
        
         BHAlbum *album = [[BHAlbum alloc] init];
         album.name = photoNameSimple;
        
         //NSUInteger photoCount = arc4random()%4 + 2;
         NSUInteger photoCount = 3;
         for (NSInteger p = 0; p < photoCount; p++)
         {
             // there are up to 25 photos available to load from the code repository
             //NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",photoIndex % 25];
             //NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
             //NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoName];
             //BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            
             NSString *photoFilePath = [[self photosDir] stringByAppendingPathComponent:photoName];
            
             __block UIImage* thumbImage = [self.photosCache objectForKey:photoName];
            
             if (p == 0)
             {
            
                 if(!thumbImage)
                 {
                    
                     //UIImage *image = [UIImage decodedImageWithImage:[UIImage imageWithContentsOfFile:photoFilePath]];
                    
                     UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
                    
                     UIGraphicsBeginImageContext(CGSizeMake(150.0f, 150.0f));
                    
                     [image drawInRect:CGRectMake(0, 0, 150.0f, 150.0f)];
                    
                     thumbImage = UIGraphicsGetImageFromCurrentImageContext();
                    //thumbImage =image;
                     UIGraphicsEndImageContext();
                    
                     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                         dispatch_async(dispatch_get_main_queue(), ^{
                         [self.photosCache setObject:image forKey:photoName];
                         });
                     });

                    
                     //dispatch_async(dispatch_get_main_queue(), ^{
                     //   [self.photosCache setObject:image forKey:photoName];
                     //});
                     // NSLog(@"THIS: %@", self.photosCache);
                }
            }
            
            BHPhoto *photo = [BHPhoto photoWithUIImage: thumbImage];
            
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
    
    currentTime = CACurrentMediaTime();
    NSLog(@"TIME2 %f", currentTime);
    
    
    [self.collectionView registerClass:[BHAlbumPhotoCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photosList = photosArray;
            //[self.collectionView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - View Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.photoAlbumLayout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
        
    } else {
        self.photoAlbumLayout.numberOfColumns = 2;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

-(void) viewDidAppear:(BOOL)animated {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
    {
        self.photoAlbumLayout.numberOfColumns = 3;
        
        // handle insets for iPhone 4 or 5
        CGFloat sideInset = [UIScreen mainScreen].preferredMode.size.width == 1136.0f ?
        45.0f : 25.0f;
        
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, sideInset, 13.0f, sideInset);
    }
    else
    {
        self.photoAlbumLayout.numberOfColumns = 2;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22.0f, 22.0f, 13.0f, 22.0f);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    BHAlbum *album = self.albums[section];
    
    return album.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BHAlbumPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    BHPhoto *photo = album.photos[indexPath.item];
    
    // load photo images in the background
    __weak CollectionViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        //UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            UIImage *image = [UIImage decodedImageWithImage:[photo image]];
            
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                BHAlbumPhotoCell *cell =
                (BHAlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                cell.imageView.image = image;
            }
        });
    }];
    
    operation.queuePriority = (indexPath.item == 0) ?
    NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal;
    
    [self.thumbnailQueue addOperation:operation];
    
    return photoCell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    BHAlbumTitleReusableView *titleView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:AlbumTitleIdentifier
                                              forIndexPath:indexPath];
    
    BHAlbum *album = self.albums[indexPath.section];
    
    titleView.titleLabel.text = album.name;
    
    return titleView;
}
























/*#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photosList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Ca: %@", self.photosList);
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    NSString *photoName = [self.photosList objectAtIndex:indexPath.row];
    
    NSString *photoFilePath = [self.photosDir stringByAppendingPathComponent:photoName];
    
    NSString *string = [photoName stringByDeletingPathExtension];
    
    NSLog(@"string == %@", string);
    
    
    NSRange rangeToSearch = NSMakeRange(0, [string length]); // get a range without the space character
    NSRange rangeOfSecondToLastSpace = [string rangeOfString:@" " options:NSBackwardsSearch range:rangeToSearch];
    
    if (rangeOfSecondToLastSpace.length > 0 && rangeOfSecondToLastSpace.location < rangeToSearch.length) {
        NSString *spaceReplacement = @"\n";
        NSString *result = [string stringByReplacingCharactersInRange:rangeOfSecondToLastSpace withString:spaceReplacement];
        
        NSLog(@"replacedString == %@", result);
        
        string = result;
    }

    cell.nameLabel.text = string;
    //cell.nameLabel.font = [UIFont fontWithName:@"GeezaPro-Bold" size:13.0];
    cell.nameLabel.font = [UIFont boldSystemFontOfSize:13.0];
    cell.nameLabel.numberOfLines = 0;
    
    __block UIImage* thumbImage = [self.photosCache objectForKey:photoName];
    cell.photoView.image = thumbImage;
    
    if(!thumbImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
            
            UIGraphicsBeginImageContext(CGSizeMake(128.0f, 128.0f));
            
            [image drawInRect:CGRectMake(0, 0, 128.0f, 128.0f)];
            
            thumbImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.photosCache setObject:thumbImage forKey:photoName];
                cell.photoView.image = thumbImage;
            });
        });
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Frame.png"]];
    
    return cell;
}*/

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.navigationItem.title isEqualToString:@"Leyendas"]) {
        [self performSegueWithIdentifier:@"legendTabSegue" sender:indexPath];
    } else {
        [self performSegueWithIdentifier:@"placeTabSegue" sender:indexPath];

    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"placesMapSegue"]) {
        Displaying_Pins_on_a_Map_ViewViewController *destViewController = segue.destinationViewController;
        destViewController.comesFromPlaceSegue = TRUE;
    } else if ([segue.identifier isEqualToString:@"legendMapSegue"]) {
        Displaying_Pins_on_a_Map_ViewViewController *destViewController = segue.destinationViewController;
        destViewController.comesFromPlaceSegue = FALSE;
    } else if ([segue.identifier isEqualToString:@"legendTabSegue"] || [segue.identifier isEqualToString:@"placeTabSegue"]) {
        [self initTabBar:sender segue: segue];
    }
    
    NSLog(@"%@", segue.identifier);
    
}


- (void)initTabBar:(id)sender segue:(UIStoryboardSegue *)segue  {
    NSIndexPath *selectedIndexPath = sender;
    
    NSString *photoName = [self.photosList objectAtIndex:selectedIndexPath.section];
    
    NSLog(@"Row: %d", selectedIndexPath.section);
    
    NSString *photoNameSimple = [[photoName componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSData *data = [photoNameSimple dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *cleanPhotoName = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    
    NSMutableString *locationKey = [NSMutableString stringWithString:cleanPhotoName];
    [locationKey appendString:@"Coord"];
    
    //NSLog(@"%@", locationKey);
    
    NSString *leyendaText = NSLocalizedString(cleanPhotoName, @"");
    NSString *leyendaLocation = NSLocalizedStringFromTable(locationKey, @"Coordinates", @"");
    
    CLLocationCoordinate2D location;
    
    if (leyendaLocation != locationKey) {
        NSString *latitude = [[leyendaLocation componentsSeparatedByString:@","] objectAtIndex:0];
        NSString *longitude = [[leyendaLocation componentsSeparatedByString:@","] objectAtIndex:1];
        
       // NSLog(@"%@",leyendaLocation);
       // NSLog(@"%@",latitude);
        //NSLog(@"%@",longitude);
        
        location = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    } else {
        location = CLLocationCoordinate2DMake(20.675672, -103.348861);
    }
    
    TabBarController *tabBarController = segue.destinationViewController;
    tabBarController.model = [[CollectionViewCellModel alloc] initWithDescription:leyendaText title:photoNameSimple location:location photosDirectory:self.photosDir];
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/



@end
