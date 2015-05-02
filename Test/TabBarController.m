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

@interface TabBarController ()

@end
static NSInteger const TEXT_DESCRIPTION_VC = 0;
static NSInteger const PICTURES_VC = 2;
static NSInteger const MAP_VC = 2;

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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"%@", segue.identifier);
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
     NSLog(@"TURURU: %lu", (unsigned long)self.selectedIndex);
}


- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [super setSelectedIndex:selectedIndex];
    NSLog(@"TURURq: %lu", (unsigned long)self.selectedIndex);
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    if ([selectedViewController isKindOfClass:[CollectionDetailVC class]]) {
        [super setSelectedViewController:selectedViewController];
        CollectionDetailVC *textDescriptionVC = (CollectionDetailVC *) selectedViewController;
        //self.tabBarNavigationItem.prompt = @"Leyenda";
        
        NSArray* paragraphs = [self.model.textDescription componentsSeparatedByString: @"\n\n"];
        
        NSMutableAttributedString *formatedText = [[NSMutableAttributedString alloc] init];
        
        for (NSString *paragrahp in paragraphs) {
            UIColor *_black=[UIColor blackColor];
            UIFont *font=[UIFont fontWithName:@"Helvetica-Bold" size:20.0f];
            UIFont *font2=[UIFont fontWithName:@"Helvetica" size:16.0f];
            
            NSMutableAttributedString *formatedParagraph=[[NSMutableAttributedString alloc] initWithString:paragrahp];
            
            [formatedParagraph addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 1)];
            [formatedParagraph addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(1, formatedParagraph.length -1)];
            [formatedParagraph addAttribute:NSForegroundColorAttributeName value:_black range:NSMakeRange(0, 1)];
            [formatedParagraph appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n\n"]];
            
            [formatedText appendAttributedString:formatedParagraph];
        }
        
        
        textDescriptionVC.detailDescription.attributedText = formatedText;
    }
    else if (![selectedViewController isKindOfClass:[Displaying_Pins_on_a_Map_ViewViewController class]]) {
        [super setSelectedViewController:selectedViewController];
    }
    else if ([selectedViewController isKindOfClass:[Displaying_Pins_on_a_Map_ViewViewController class]]) {
        Displaying_Pins_on_a_Map_ViewViewController *mapController = (Displaying_Pins_on_a_Map_ViewViewController *) selectedViewController;

        NSLog(@"%f",self.model.location.latitude);
        NSLog(@"%f",self.model.location.longitude);

        
        
        mapController.location = self.model.location;
        
        
        NSLog(@"%f", mapController.location.latitude );
        NSLog(@"%f", mapController.location.longitude );
        
        [selectedViewController.view setNeedsDisplay];
        [super setSelectedViewController:selectedViewController];
    }
    
    
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"Tq: %lu", (unsigned long)self.selectedIndex);

}





@end
