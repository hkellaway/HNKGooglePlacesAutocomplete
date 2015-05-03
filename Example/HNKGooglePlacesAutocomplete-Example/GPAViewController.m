//
//  GPAViewController.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "GPAViewController.h"

#import <CoreLocation/CLPlacemark.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

#import "CLPlacemark+HNKAdditions.h"

@interface GPAViewController ()

@end

@implementation GPAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey:@"AIzaSyAkR80JQgRgfnqBl6Db2RsnmkCG1LhuVn8"];

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
