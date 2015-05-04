//
//  HNKDemoViewController.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "HNKDemoViewController.h"

#import <CoreLocation/CLPlacemark.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <MapKit/MapKit.h>

#import "CLPlacemark+HNKAdditions.h"

@interface HNKDemoViewController ()

@property (nonatomic, strong) HNKGooglePlacesAutocompleteQuery *searchQuery;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation HNKDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];

    void (^GPAViewControllerQueryCompletion)(NSArray *, NSError *) = ^(NSArray *places, NSError *error) {
        if (error) {
            NSLog(@"ERROR = %@", error);
            return;
        }

        NSLog(@"PLACES = %@", places);
    };

    // Error-causing requests
    [self.searchQuery fetchPlacesForSearchQuery:@"" completion:GPAViewControllerQueryCompletion];
    [self.searchQuery fetchPlacesForSearchQuery:nil completion:GPAViewControllerQueryCompletion];

    // Successful request
    [self.searchQuery fetchPlacesForSearchQuery:@"Vict" completion:GPAViewControllerQueryCompletion];

    // Placemark
    [self.searchQuery fetchPlacesForSearchQuery:
                          @"Vict" completion:^(NSArray *places, NSError *error) {

        if (error) {
            NSLog(@"ERROR = %@", error);
            return;
        }

        for (HNKQueryResponsePrediction *place in places) {
            [CLPlacemark hnk_placemarkFromGooglePlace:place
                                               apiKey:self.searchQuery.apiKey
                                           completion:^(CLPlacemark *placemark, NSString *address, NSError *error) {

                                               if (error) {
                                                   NSLog(@"ERROR DURING PLACEMARK CREATION = %@", error);
                                                   return;
                                               }

                                               NSLog(@"PLACEMARK ADDRESS = %@", address);

                                           }];
        }

    }];
}

@end
