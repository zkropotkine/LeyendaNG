//
//  TabBarController.m
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 4/30/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import "TabBarController.h"
#import "CollectionDetailVC.h"
#import "Displaying_Pins_on_a_Map_ViewViewController.h"
#import "ViewController.h"

@interface TabBarController ()

@end


@implementation TabBarController

- (id) init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarNavigationItem.title = self.model.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    if ([selectedViewController isKindOfClass:[CollectionDetailVC class]])
    {
        [super setSelectedViewController:selectedViewController];
        
        NSArray* paragraphs = [self.model.textDescription componentsSeparatedByString: @"\n\n"];
        
        NSMutableAttributedString *formatedText = [[NSMutableAttributedString alloc] init];
        
        for (NSString *paragrahp in paragraphs)
        {
            UIColor *_black=[UIColor blackColor];
            UIFont *startFont   =[UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
            UIFont *generalFont =[UIFont fontWithName:@"Helvetica" size:16.0f];
            
            NSMutableAttributedString *formatedParagraph=[[NSMutableAttributedString alloc] initWithString:paragrahp];
            
            [formatedParagraph addAttribute:NSFontAttributeName value:startFont range:NSMakeRange(0, 1)];
            [formatedParagraph addAttribute:NSFontAttributeName value:generalFont range:NSMakeRange(1, formatedParagraph.length -1)];
            [formatedParagraph addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 1)];
            [formatedParagraph appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n\n"]];
            
            [formatedText appendAttributedString:formatedParagraph];
        }
        
        CollectionDetailVC *textDescriptionVC = (CollectionDetailVC *) selectedViewController;
        textDescriptionVC.detailDescription.attributedText = formatedText;
    }
    else if ([selectedViewController isKindOfClass:[ViewController class]])
    {
        ViewController *galleryController = (ViewController *) selectedViewController;

        //TODO: Check this implementation
        galleryController.photosDirectory = self.model.photosDirectory;
        galleryController.galleryTitle = [self.model.title copy];
        
        [super setSelectedViewController:selectedViewController];


    }
    else if ([selectedViewController isKindOfClass:[Displaying_Pins_on_a_Map_ViewViewController class]])
    {
        Displaying_Pins_on_a_Map_ViewViewController *mapController = (Displaying_Pins_on_a_Map_ViewViewController *) selectedViewController;
        mapController.location = self.model.location;

        [selectedViewController.view setNeedsDisplay];
        [super setSelectedViewController:selectedViewController];
    }
}

@end
