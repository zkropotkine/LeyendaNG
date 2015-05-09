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

static NSString * const AlbumTitleIdentifier = @"AlbumTitle";
static NSString * const PhotoCellIdentifier = @"PhotoCell";


@interface CollectionViewController ()

    @property (strong, nonatomic) NSArray *photosList;
    @property (strong, nonatomic) NSMutableDictionary *photosCache;
    @property (strong, nonatomic) NSString *photosDir;
    @property (nonatomic, strong) NSMutableArray *albums;
    @property (nonatomic, strong) NSOperationQueue *thumbnailQueue;
@end

@implementation CollectionViewController

-(NSString*) photosDirectory {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Leyendas"];
}


static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *patternImage = [UIImage imageNamed:@"concrete_wall"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:patternImage];

    
    [super viewDidLoad];

    
    self.albums = [NSMutableArray array];
    
    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];
    
    NSInteger photoIndex = 0;
    
    for (NSInteger a = 0; a < 12; a++) {
        BHAlbum *album = [[BHAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %d",a + 1];
        
        NSUInteger photoCount = arc4random()%4 + 2;
        for (NSInteger p = 0; p < photoCount; p++) {
            // there are up to 25 photos available to load from the code repository
            NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg",photoIndex % 25];
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
            BHPhoto *photo = [BHPhoto photoWithImageURL:photoURL];
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
    
    
    [self.collectionView registerClass:[BHAlbumPhotoCell class]
            forCellWithReuseIdentifier:PhotoCellIdentifier];
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
    
    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
    
    NSLog(@"Title == %@", self.navigationItem.title);
    NSLog(@"Title == %d", [self.navigationItem.title isEqualToString:@"Leyendas"]);
    
    if ([self.navigationItem.title isEqualToString:@"Leyendas"]) {
        self.photosDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Leyendas"];
    } else {
        self.photosDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Lugares"];
    }
    NSLog(@"%@", self.photosDir);
    
    
    NSArray * photosArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.photosDir error:nil];
    NSLog(@"%@", photosArray);
    self.photosCache = [NSMutableDictionary dictionary];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photosList = photosArray;
            [self.collectionView reloadData];
        });
    });
    
    
    
    [self.collectionView registerClass:[BHAlbumTitleReusableView class]
            forSupplementaryViewOfKind:BHPhotoAlbumLayoutAlbumTitleKind
                   withReuseIdentifier:AlbumTitleIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

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
}

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
    
    NSString *photoName = [self.photosList objectAtIndex:selectedIndexPath.row];
    
    NSString *photoNameSimple = [[photoName componentsSeparatedByString:@"."] objectAtIndex:0];
    
    NSData *data = [photoNameSimple dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *cleanPhotoName = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    //NSLog(@"%@", cleanPhotoName);
    
    NSMutableString *locationKey = [NSMutableString stringWithString:cleanPhotoName];
    [locationKey appendString:@"Coord"];
    
    //NSLog(@"%@", locationKey);
    
    NSString *leyendaText = NSLocalizedString(cleanPhotoName, @"");
    NSString *leyendaLocation = NSLocalizedStringFromTable(locationKey, @"Coordinates", @"");
    
    CLLocationCoordinate2D location;
    
    if (leyendaLocation != locationKey) {
        NSString *latitude = [[leyendaLocation componentsSeparatedByString:@","] objectAtIndex:0];
        NSString *longitude = [[leyendaLocation componentsSeparatedByString:@","] objectAtIndex:1];
        
        NSLog(@"%@",leyendaLocation);
        NSLog(@"%@",latitude);
        NSLog(@"%@",longitude);
        
        location = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
    } else {
        location = CLLocationCoordinate2DMake(20.675672, -103.348861);
    }
    
    TabBarController *tabBarController = segue.destinationViewController;
    tabBarController.model = [[CollectionViewCellModel alloc] initWithDescription:leyendaText title:photoNameSimple location:location];
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath;
{
    BHAlbumTitleReusableView *titleView =
    [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                       withReuseIdentifier:AlbumTitleIdentifier
                                              forIndexPath:indexPath];
    
    NSString *photoName = self.photosList[indexPath.section];
    
    titleView.titleLabel.text = photoName;
    
    return titleView;
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
