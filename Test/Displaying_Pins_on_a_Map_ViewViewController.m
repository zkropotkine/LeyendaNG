//
//  Displaying_Pins_on_a_Map_ViewViewController.m
//  Leyenda
//
//  Created by Daniel Rodriguez on 1/13/13.
//  Copyright (c) 2013 Daniel Rodriguez. All rights reserved.
//

#import "Displaying_Pins_on_a_Map_ViewViewController.h"
#import "MyAnnonation.h"

@interface Displaying_Pins_on_a_Map_ViewViewController ()
- (IBAction)returnHomePage:(id)sender;
@end

@implementation Displaying_Pins_on_a_Map_ViewViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /* Create a map as big as our view */
    self.myMapView = [[MKMapView alloc]
                      initWithFrame:self.view.bounds];
    
    
    /* Set the map type to Standard */
    self.myMapView.mapType = MKMapTypeStandard;
    self.myMapView.showsUserLocation=YES;
    
    self.myMapView.autoresizingMask =
    UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleHeight;
    
    /* Add it to our view */
    [self.view addSubview:self.myMapView];
    
    NSLog(@"User's latitude is: %f", self.location.latitude );
    NSLog(@"User's longitude is: %f", self.location.longitude );
    
    
    CLLocationCoordinate2D maplocation;
    if (self.location.latitude != 0 && self.location.longitude != 0) {
        maplocation = self.location;
    
        /* Create the annotation using the location */
        MyAnnonation *annotation =
        //[[MyAnnonation alloc] initWithCoordinates:maplocation
        //                                    title:@"My Title"
        //                                 subTitle:@"My Sub Title"];
        
        [[MyAnnonation alloc] initWithCoordinates:maplocation
                                            title:self.markTitle];
        
        /* And eventually add it to the map */
        [self.myMapView addAnnotation:annotation];
        
        
        //CLLocationCoordinate2D newcordinate =   CLLocationCoordinate2DMake(20.715336, -103.36146);
        CLLocationCoordinate2D oldcordinate =   CLLocationCoordinate2DMake(20.718869,-103.360675);
        
        [self getPathDirections:oldcordinate withDestination:maplocation];
        
        
    } else {
        
        NSString *stringsPath;
        if (self.comesFromPlaceSegue)
        {
            stringsPath = [[NSBundle mainBundle] pathForResource:@"PlacesCoordinates" ofType:@"strings"];
            NSLog(@"Two");
        }
        else
        {
            stringsPath = [[NSBundle mainBundle] pathForResource:@"LegendsCoordinates" ofType:@"strings"];
            NSLog(@"One");
        }
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:stringsPath];
        NSMutableArray *annotations = [[NSMutableArray alloc] init];
        
        for(id key in dictionary) {
            NSString *keyName = key;
            NSString *location = [dictionary objectForKey:key];
            NSLog(@"key=%@ value=%@", keyName, location);
            
            NSString *locationName = [[keyName componentsSeparatedByString:@"Coord"] objectAtIndex:0];
            NSString *latitude = [[location componentsSeparatedByString:@","] objectAtIndex:0];
            NSString *longitude = [[location componentsSeparatedByString:@","] objectAtIndex:1];
            
            NSLog(@"%@",latitude);
            NSLog(@"%@",longitude);
            
            maplocation = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
            
            MyAnnonation *annotation =
            [[MyAnnonation alloc] initWithCoordinates:maplocation
                                                title:locationName
                                                subTitle:locationName];
            
            [annotations addObject:annotation];
        }
        
        /* And eventually add it to the map */
        [self.myMapView addAnnotations:annotations];
    }
    
    
    if ([CLLocationManager locationServicesEnabled]){
        self.myLocationManager = [[CLLocationManager alloc] init];
        self.myLocationManager.delegate = self;
        
        if ([self.myLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.myLocationManager requestWhenInUseAuthorization];
        }
        
        [self.myLocationManager startUpdatingLocation];
        // 500 meters x 500 meters
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(maplocation, 1000, 1000);
        MKCoordinateRegion adjustedRegion = [self.myMapView regionThatFits:viewRegion];
        [self.myMapView setRegion:adjustedRegion animated:YES];
        self.myMapView.showsUserLocation = YES;
        NSLog(@"Deberia de jalar");
        
        
        
        
    } else {
        /* Location services are not enabled.
         Take appropriate action: for instance, prompt the
         user to enable location services */
        NSLog(@"Location services are not enabled");
    }
    
    self.title = @"Mapa";
    self.navigationItem.hidesBackButton = false;
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc]init];
    btn.title=@"Back";
    
    self.navigationItem.backBarButtonItem=btn;
    

    
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation :(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //[locations lastObject];
    //NSLog(@"%@", [locations lastObject]);
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    /* We received the new location */
    
    NSLog(@"Latitude = %f", newLocation.coordinate.latitude);
    NSLog(@"Longitude = %f", newLocation.coordinate.longitude);
    
    
    CLLocationCoordinate2D newcordinate =   CLLocationCoordinate2DMake(20.715336, -103.36146);
    CLLocationCoordinate2D oldcordinate =   CLLocationCoordinate2DMake(20.718869,-103.360675);
    
    MKMapPoint * pointsArray =
    malloc(sizeof(CLLocationCoordinate2D)*2);
    
    pointsArray[0]= MKMapPointForCoordinate(oldcordinate);
    pointsArray[1]= MKMapPointForCoordinate(newcordinate);
    
    MKPolyline *  routeLine = [MKPolyline polylineWithPoints:pointsArray count:2];
    free(pointsArray);
    
    
    
    
    
    [self.myMapView addOverlay:routeLine];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"WO");
    
    //[self.myLocationManager stopUpdatingLocation];
}

-(void) viewDidAppear:(BOOL)animated {
    //[self.myLocationManager startUpdatingLocation];
}


-(void)getPathDirections:(CLLocationCoordinate2D)source withDestination:(CLLocationCoordinate2D)destination{
    
    MKPlacemark *placemarkSrc = [[MKPlacemark alloc] initWithCoordinate:source addressDictionary:nil];
    MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark:placemarkSrc];
    MKPlacemark *placemarkDest = [[MKPlacemark alloc] initWithCoordinate:destination addressDictionary:nil];
    MKMapItem *mapItemDest = [[MKMapItem alloc] initWithPlacemark:placemarkDest];
    [mapItemSrc setName:@"name1"];
    [mapItemDest setName:@"name2"];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:mapItemSrc];
    [request setDestination:mapItemDest];
    [request setTransportType:MKDirectionsTransportTypeWalking];
    request.requestsAlternateRoutes = NO;
    
    
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            for (MKRoute *route in [response routes]) {
                [_myMapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
                // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
            }
        } else {
            NSLog(@"HOOOO");
        }
    }];
    
}



- (void)generateRoute {
    CLLocationCoordinate2D newcordinate =   CLLocationCoordinate2DMake(20.715336, -103.36146);
    MKPlacemark *placemarkSrc = [[MKPlacemark alloc] initWithCoordinate:newcordinate addressDictionary:nil];
    MKMapItem *mapItemSrc = [[MKMapItem alloc] initWithPlacemark:placemarkSrc];
    
    
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = [MKMapItem mapItemForCurrentLocation];
    request.destination = mapItemSrc;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         if (error) {
             // Handle Error
         } else {
             [self showRoute:response];
         }
     }];
}

- (void)showRoute:(MKDirectionsResponse *)response {
    [self.myMapView removeOverlays:self.myMapView.overlays];
    for (MKRoute *route in response.routes)
    {
        [self.myMapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
    }
    //[self fitRegionToRoute];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor blueColor];
    renderer.alpha = 0.7;
    renderer.lineWidth = 4.0;
    
    return renderer;
}

@end
