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

- (void)tappedImage:(UITapGestureRecognizer *)recognizer
{
    // Hidding/Unhidding tab and navigation bars.
    self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    self.tabBarController.tabBar.hidden = !self.tabBarController.tabBar.hidden;
}

@end