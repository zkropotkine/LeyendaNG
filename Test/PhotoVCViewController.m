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

@end

@implementation PhotoVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSString *photosDir = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Photos/Leyendas"];
    
    //NSArray * photosArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:photosDir error:nil];
    
    //NSString *photoName = [photosArray objectAtIndex:11];
    
    //NSString *photoFilePath = [photosDir stringByAppendingPathComponent:photoName];
    
    //NSLog(@"Entro aqui %@", photoFilePath);
    
    //UIImage *image = [UIImage imageWithContentsOfFile:photoFilePath];
    
   // self.photoImage.image = image;
    NSLog(@"Esto : %@", self.path);
    UIImage *image = [UIImage imageNamed:self.path];
    
    self.photoImage.image = image;
    
   /* self.navigationController.hidesBarsOnTap = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.photoImage.userInteractionEnabled = YES;
    
    
    NSLog(@"%@", self.photoImage.description);
     NSLog(@"%@", self.photoImage.image);
     NSLog(@"%@", self.photoImage);
    */
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *image = [UIImage decodedImageWithImage:[UIImage imageWithContentsOfFile:@"/Resources/Images/photo-01.png"]];

        //dispatch_async(dispatch_get_main_queue(), ^{
            self.photoImage.image = image;
        //});
    });*/
                   
                   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*-(void) viewDidAppear:(BOOL)animated {
    self.navigationController.hidesBarsOnSwipe = false;
    self.navigationController.hidesBarsOnTap = true;
}*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"WORKS");
    if ([self isMovingFromParentViewController]) {
        //specifkic stuff for being popped off stack
       
        
        self.navigationController.hidesBarsOnSwipe = false;
        self.navigationController.hidesBarsOnTap = false;
        [self.tabBarController.tabBar setHidden:NO];
    }
}


- (void)tappedImage:(UITapGestureRecognizer *)recognizer
{
     NSLog(@"KIND");
    
    if (self.navigationController.navigationBarHidden)
    {
        self.navigationController.navigationBarHidden = false;
    }
    else
    {
        self.navigationController.navigationBarHidden = true;
    }
    
    if (self.tabBarController.tabBar.hidden)
    {
        self.tabBarController.tabBar.hidden = false;
    }
    else
    {
        self.tabBarController.tabBar.hidden = true;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
