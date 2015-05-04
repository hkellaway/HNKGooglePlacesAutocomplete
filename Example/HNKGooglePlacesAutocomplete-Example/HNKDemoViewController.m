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

#import "CLPlacemark+HNKAdditions.h"

@interface HNKDemoViewController ()

@end

@implementation HNKDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *apiKey = @"AIzaSyAkR80JQgRgfnqBl6Db2RsnmkCG1LhuVn8";

    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey:apiKey];

    void (^GPAViewControllerQueryCompletion)(NSArray *, NSError *) = ^(NSArray *places, NSError *error) {
        if (error) {
            NSLog(@"ERROR = %@", error);
            return;
        }

        NSLog(@"PLACES = %@", places);
    };

    // Error-causing requests
    [[HNKGooglePlacesAutocompleteQuery sharedQuery] fetchPlacesForSearchQuery:@""
                                                                   completion:GPAViewControllerQueryCompletion];
    [[HNKGooglePlacesAutocompleteQuery sharedQuery] fetchPlacesForSearchQuery:nil
                                                                   completion:GPAViewControllerQueryCompletion];

    // Successful request
    [[HNKGooglePlacesAutocompleteQuery sharedQuery] fetchPlacesForSearchQuery:@"Vict"
                                                                   completion:GPAViewControllerQueryCompletion];

    // Placemark
    [[HNKGooglePlacesAutocompleteQuery sharedQuery] fetchPlacesForSearchQuery:
                                                        @"Vict" completion:^(NSArray *places, NSError *error) {

        if (error) {
            NSLog(@"ERROR = %@", error);
            return;
        }

        for (HNKQueryResponsePrediction *place in places) {
            [CLPlacemark hnk_placemarkFromGooglePlace:place
                                               apiKey:apiKey
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
