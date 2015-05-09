//
//  PhotoVCViewController.m
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 5/8/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import "PhotoVCViewController.h"

@interface PhotoVCViewController ()

@end

@implementation PhotoVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //SEL selector = NSSelectorFromString(@"tappedImage:");
    //UIGestureRecognizer *tapGestureRecognizer = [[UIGestureRecognizer alloc] initWithTarget:self action:selector];
    //[self.photoImage addGestureRecognizer:tapGestureRecognizer];
    
    self.navigationController.hidesBarsOnTap = true;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedImage:)];
    [self.view addGestureRecognizer:tapGesture];
    
    
    self.photoImage.userInteractionEnabled = YES;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void) viewDidAppear:(BOOL)animated {
    self.navigationController.hidesBarsOnSwipe = false;
    self.navigationController.hidesBarsOnTap = true;
}

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
    
    //self.tabBarController.tabBar.hidden = true;
    
    //[self.tabBarController.tabBar setHidden:YES];
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
