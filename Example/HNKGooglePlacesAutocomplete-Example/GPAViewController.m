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
    [[HNKGooglePlacesAutocompleteQuery sharedQuery] fetchPlacesForSearchQuery:@"Vict"
                                                                   completion:^(NSArray *places, NSError *error) {

                                                                       if (error) {
                                                                           NSLog(@"ERROR = %@", error);
                                                                           return;
                                                                       }

                                                                       NSLog(@"PLACES = %@", places);

                                                                   }];
}

@end
