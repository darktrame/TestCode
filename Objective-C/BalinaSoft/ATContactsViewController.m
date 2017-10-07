//
//  ContactsViewController.m
//  BalinaSoft
//
//  Created by Андрей Трофимов on 2/12/17.
//  Copyright © 2017 Андрей Трофимов. All rights reserved.
//

#import "ATContactsViewController.h"
#import "SWRevealViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "ATMapAnnotation.h"

@interface ATContactsViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem* revealButtonItem;

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLLocation* currentLocation;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ATContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController){
        [self.revealButtonItem setTarget:self.revealViewController];
        [self.revealButtonItem setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.currentLocation = [locations lastObject];
    
    if (self.currentLocation.horizontalAccuracy > 0) {
        [manager stopUpdatingLocation];
        
        ATMapAnnotation* annotation = [[ATMapAnnotation alloc] init];
        
        annotation.title = @"Это вы!";
        annotation.coordinate = self.currentLocation.coordinate;
        
        ATMapAnnotation* annotationRest = [[ATMapAnnotation alloc] init];
        
        annotationRest.title = @"Мы здесь!";
        annotationRest.subtitle = @"Адрес: 450071, г. Уфа, ул. Ростовская, д. 18.";
        annotationRest.coordinate = CLLocationCoordinate2DMake(54.753595, 56.014775);
        
        [self.mapView addAnnotation:annotation];
        [self.mapView addAnnotation:annotationRest];
    }
}

@end
