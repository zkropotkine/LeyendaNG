//
//  PhotoVCViewController.h
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 5/8/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import "ViewController.h"

@interface PhotoVCViewController : UIViewController<UIGestureRecognizerDelegate>
{
    CGFloat previousScale;
    CGFloat previousRotation;
    
    CGFloat beginX;
    CGFloat beginY;

}
@property (strong, nonatomic) IBOutlet UIImageView *photoImage;
@property (strong, nonatomic) NSString *path;
-(void)configureWithImage:(UIImage *)paramImage;
- (IBAction)resetImage:(id)sender;
@end
