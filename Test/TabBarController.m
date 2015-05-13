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
    
    NSArray* newArray = [NSArray arrayWithArray:self.viewControllers];
    NSLog(@" newArray count = %d", [newArray count]);
    
    NSLog(@" newArray count = %@", newArray);
    
    //NSLog(@" newArray count = %@", [[self.viewControllers objectAtIndex:2] title]);
    
    self.tabBar.hidden = !self.tabBarController.tabBar.hidden;
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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        [self configureForInitialization];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self configureForInitialization];
    }
    
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.segmentedControl.selectedSegmentIndex = self.selectedIndex;
    
    [self hideTabBar];
}

- (IBAction)segmentTapped:(UISegmentedControl *)sender {

//self.selectedIndex = sender.selectedSegmentIndex;
    
    
    /*NSArray* newArray = [NSArray arrayWithArray:self.viewControllers];
    NSLog(@" newArray count = %d", [newArray count]);
     NSLog(@" newArray count = %@", newArray);
    
    NSLog(@"%@", [self.viewControllers objectAtIndex:2]);
    // [super setSelectedIndex:sender.selectedSegmentIndex];
    
    ViewController *galleryController = (ViewController *) [self.viewControllers objectAtIndex:2];
    
    //TODO: Check this implementation
    galleryController.photosDirectory = self.model.photosDirectory;
    galleryController.galleryTitle = [self.model.title copy];*/
    
    
    [self setSelectedViewController: [self.viewControllers objectAtIndex:sender.selectedSegmentIndex]];
    
    self.selectedIndex = sender.selectedSegmentIndex;

    
}

- (void)configureForInitialization {
    self.delegate = self;
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:[self.tabBar.items count]];
    
    
    NSLog(@"%@", titles);
   // NSLog(@"%d", [self.tabBar.items count]);
    
     NSLog(@"%@", self.tabBarController.tabBar.items);
    
    NSLog(@"%@", self.tabBarController.tabBarItem.title);
    
    NSLog(@"%@", self.tabBar.items);
    
    
    for (UITabBarItem *tabBarItem in self.tabBar.items) {
     [titles addObject:tabBarItem.title];
        
        
    }
    
    //[titles addObject:@"Info"];
    //[titles addObject:@"Mapa"];
    //[titles addObject:@"Fotos"];
    
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:[titles copy]];
    _segmentedControl.selectedSegmentIndex = self.selectedIndex;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
#endif
    
    [_segmentedControl addTarget:self
                          action:@selector(segmentTapped:)
                forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segmentedControl;
}


// This borrows code from @bshirley at http://stackoverflow.com/questions/1982172/iphone-is-it-possible-to-hide-the-tabbar
- (void)hideTabBar {
    UITabBar *tabBar = self.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews firstObject];  // UITransitionView
    UIView *window = parent.superview;
    
    CGRect tabFrame = tabBar.frame;
    tabFrame.origin.y = CGRectGetMaxY(window.bounds);
    tabBar.frame = tabFrame;
    content.frame = window.bounds;
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [self hideTabBar];
    NSLog(@"1");
}



-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Scroll to the saved position prior to screen rotate
   [self hideTabBar];
    NSLog(@"2");
}


-(void) viewDidAppear:(BOOL)animated {
NSLog(@"3");
    /*UITabBar *tabBar = self.tabBarController.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
    UIView *window = parent.superview;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect tabFrame = tabBar.frame;
                         tabFrame.origin.y = CGRectGetMaxY(window.bounds) - CGRectGetHeight(tabBar.frame);
                         tabBar.frame = tabFrame;
                         
                         CGRect contentFrame = content.frame;
                         contentFrame.size.height -= tabFrame.size.height;
                     }];*/
    
    [self hideTabBar];
    
    self.tabBar.frame =CGRectMake(0,0,320,50);
}

@end
