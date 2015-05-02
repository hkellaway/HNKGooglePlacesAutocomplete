//
//  GPAViewController.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "GPAViewController.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>

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
}

@end
