//
//  TabBarController.m
//  LeyendaNG
//
//  Created by Daniel Rodriguez on 4/30/15.
//  Copyright (c) 2015 Daniel Rodriguez. All rights reserved.
//

#import "TabBarController.h"

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
    // Do any additional setup after loading the view.
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
    [super setSelectedViewController:selectedViewController];
    NSLog(@"TURURE: %lu", (unsigned long)self.selectedIndex);
    
    NSLog(@"Tittle: %@", self.model.title);
    NSLog(@"Description: %@", self.model.textDescription);
}

@end
