//
//  HNKGooglePlacesAutocompleteServerSpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/28/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteServer.h>
#import <HNKServerFacade/HNKServer.h>

SPEC_BEGIN(HNKGooglePlacesAutocompleteServerSpec)

describe(@"HNKGooglePlacesAutocompleteServer", ^{

    describe(@"Method: initialize",
             ^{

                 it(@"Should setup HNKServer",
                    ^{
                        [[HNKServer should] receive:@selector(setupWithBaseUrl:)
                                      withArguments:@"https://maps.googleapis.com/maps/api/"];

                        [HNKGooglePlacesAutocompleteServer initialize];
                    });
             });

    describe(@"Method: GET:parameters:completion:",
             ^{
                 it(@"Should call HNKServer GET",
                    ^{
                        [[HNKServer should]
                                  receive:@selector(GET:parameters:completion:)
                            withArguments:@"place/autocomplete/json",
                                          @{ @"input" : @"Vict",
                                             @"key" : @"AIzaSyAkR80JQgRgfnqBl6Db2RsnmkCG1LhuVn8" },
                                          any()];

                        [HNKGooglePlacesAutocompleteServer GETRequestWithInput:@"Vict" completion:nil];

                    });
             });

});

SPEC_END