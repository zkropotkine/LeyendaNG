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


@interface CollectionViewController ()
    @property (strong, nonatomic) NSArray *photosList;
    @property (strong, nonatomic) NSMutableDictionary *photosCache;
    @property (strong, nonatomic) NSString *photosDir;
@end

@implementation CollectionViewController

-(NSString*) photosDirectory {
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Leyendas"];
}


static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    NSLog(@"Cosa: %@", self.photosList);
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
    } else if ([segue.identifier isEqualToString:@"legendTabSegue"]) {
        
        NSIndexPath *selectedIndexPath = sender;
        
        NSString *photoName = [self.photosList objectAtIndex:selectedIndexPath.row];
        
        NSString *photoNameSimple = [[photoName componentsSeparatedByString:@"."] objectAtIndex:0];
        
        NSData *data = [photoNameSimple dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *cleanPhotoName = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] stringByReplacingOccurrencesOfString:@"?" withString:@""];
        NSLog(@"%@", cleanPhotoName);
        
        NSMutableString *locationKey = [NSMutableString stringWithString:cleanPhotoName];
        [locationKey appendString:@"Coord"];
        
        NSLog(@"%@", locationKey);
        
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
    } else if ([segue.identifier isEqualToString:@"placeTabSegue"]) {
    
    }
    
    NSLog(@"%@", segue.identifier);
    
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
