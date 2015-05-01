//
//  HNKGooglePlacesAutocompleteQuerySpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/30/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteServer.h>

@interface HNKGooglePlacesAutocompleteQuery (KiwiExposedMethods)

@property (nonatomic, strong) NSString *apiKey;

@end

SPEC_BEGIN(HNKGooglePlacesAutocompleteQuerySpec)

__block HNKGooglePlacesAutocompleteQuery *testInstance;

beforeAll(^{

    testInstance = [HNKGooglePlacesAutocompleteQuery sharedQuery];

});

describe(@"HNKGooglePlacesAutocompleteQuery", ^{

    specify(^{

        [[testInstance should] beNonNil];

    });

    describe(
        @"Method: fetchPlacesForSearchQuery:completion:",
        ^{

            it(@"Should make a GET request to the Server",
               ^{
                   [[HNKGooglePlacesAutocompleteServer should]
                             receive:@selector(GET:parameters:completion:)
                       withArguments:@"place/autocomplete/json",
                                     @{
                                         @"input" : @"Vict",
                                         @"key" : @"AIzaSyAkR80JQgRgfnqBl6Db2RsnmkCG1LhuVn8",
                                         @"radius" : @500
                                     },
                                     any()];

                   [[HNKGooglePlacesAutocompleteQuery sharedQuery] fetchPlacesForSearchQuery:@"Vict" completion:nil];

               });

        });

});

SPEC_END