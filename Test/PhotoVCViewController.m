//
//  PhotoVCViewController.m
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 5/8/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import "PhotoVCViewController.h"
#import "UIImage+Decompression.h"

@interface PhotoVCViewController ()
@property (nonatomic, strong) UIImage *capturedImage;

@end

@implementation PhotoVCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Adding Gestures
    self.photoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage:)];
    [self.view addGestureRecognizer:tapGesture];
    
   
    
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetImage:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    
     [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    

    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    [self.view addGestureRecognizer:panGesture];
    
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotateImage:)];
    [self.view addGestureRecognizer:rotationGesture];
    
    // Showing image
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UIImage *image = [UIImage decodedImageWithImage : self.capturedImage];

        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoImage.image = image;
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureWithImage:(UIImage *)paramImage
{
    self.capturedImage = paramImage;
}

- (IBAction)resetImage:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    self.photoImage.transform = CGAffineTransformIdentity;
    
    [self.photoImage setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    
    [UIView commitAnimations];
}

- (void)tappedImage:(UITapGestureRecognizer *)recognizer
{
    // Hidding/Unhidding tab and navigation bars.
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    self.tabBarController.tabBar.hidden = !self.tabBarController.tabBar.hidden;
}

- (void)scaleImage:(UIPinchGestureRecognizer *)recognizer
{
    
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        
        previousScale = 1.0;
        return;
    }
    
    CGFloat newScale = 1.0 - (previousScale - [recognizer scale]);
    
    CGAffineTransform currentTransformation = self.photoImage.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransformation, newScale, newScale);
    
    self.photoImage.transform = newTransform;
    
    previousScale = [recognizer scale];
}

- (void)moveImage:(UIPanGestureRecognizer *)recognizer
{
    CGPoint newCenter = [recognizer translationInView:self.view];
    
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        
        beginX = self.photoImage.center.x;
        beginY = self.photoImage.center.y;
    }
    
    newCenter = CGPointMake(beginX + newCenter.x, beginY + newCenter.y);
    
    [self.photoImage setCenter:newCenter];
    
}

- (void)rotateImage:(UIRotationGestureRecognizer *)recognizer
{
    
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        
        previousRotation = 0.0;
        return;
    }
    
    CGFloat newRotation = 0.0 - (previousRotation - [recognizer rotation]);
    
    CGAffineTransform currentTransformation = self.photoImage.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransformation, newRotation);
    
    self.photoImage.transform = newTransform;
    
    previousRotation = [recognizer rotation];
}

@end