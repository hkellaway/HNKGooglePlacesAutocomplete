//
//  HNKGooglePlacesAutocompleteQueryConfigSpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 5/9/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

SPEC_BEGIN(HNKGooglePlacesAutocompleteQueryConfigSpec)

describe(@"HNKGooglePlacesAutocompleteQueryConfig", ^{

    describe(@"translateToServerRequestParameters",
             ^{

                 context(@"Latitude and longitude set to 0",
                         ^{
                             __block HNKGooglePlacesAutocompleteQueryConfig *testInstanceNoLocation;

                             beforeEach(^{

                                 testInstanceNoLocation = [[HNKGooglePlacesAutocompleteQueryConfig alloc] init];
                                 testInstanceNoLocation.country = @"abc";
                                 testInstanceNoLocation.filter = HNKGooglePlaceTypeAutocompleteFilterRegion;
                                 testInstanceNoLocation.language = @"def";
                                 testInstanceNoLocation.latitude = 0;
                                 testInstanceNoLocation.longitude = 0;
                                 testInstanceNoLocation.offset = 100;
                                 testInstanceNoLocation.searchRadius = 1000;

                             });

                             it(@"Should not include location in parameters",
                                ^{
                                    NSDictionary *params = [testInstanceNoLocation translateToServerRequestParameters];

                                    [[params should] equal:@{
                                        @"components=country" : @"abc",
                                        @"language" : @"def",
                                        @"offset" : @(100),
                                        @"radius" : @(1000),
                                        @"types" : @"(regions)"
                                    }];

                                });

                         });

                 context(@"Latitude and Longitude set",
                         ^{

                             it(@"Should return correct dictionary",
                                ^{
                                    HNKGooglePlacesAutocompleteQueryConfig *testInstance =
                                        [[HNKGooglePlacesAutocompleteQueryConfig alloc] init];

                                    testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc] init];
                                    testInstance.country = nil;
                                    testInstance.filter = HNKGooglePlaceTypeAutocompleteFilterAll;
                                    testInstance.language = nil;
                                    testInstance.latitude = 0;
                                    testInstance.longitude = 0;
                                    testInstance.offset = NSNotFound;
                                    testInstance.searchRadius = NSNotFound;

                                    NSDictionary *params = [testInstance translateToServerRequestParameters];

                                    [[params should] equal:@{}];

                                    testInstance.latitude = 50.5;
                                    testInstance.longitude = 150.5;

                                    params = [testInstance translateToServerRequestParameters];

                                    [[params should] equal:@{ @"location" : @"50.500000,150.500000" }];

                                    testInstance.country = @"abc";
                                    testInstance.language = @"def";

                                    params = [testInstance translateToServerRequestParameters];

                                    [[params should] equal:@{
                                        @"components=country" : @"abc",
                                        @"language" : @"def",
                                        @"location" : @"50.500000,150.500000"
                                    }];

                                    testInstance.offset = 100;
                                    testInstance.searchRadius = 1000;

                                    params = [testInstance translateToServerRequestParameters];

                                    [[params should] equal:@{
                                        @"components=country" : @"abc",
                                        @"language" : @"def",
                                        @"location" : @"50.500000,150.500000",
                                        @"offset" : @(100),
                                        @"radius" : @(1000)
                                    }];

                                    testInstance.filter = HNKGooglePlaceTypeAutocompleteFilterRegion;

                                    params = [testInstance translateToServerRequestParameters];

                                    [[params should] equal:@{
                                        @"components=country" : @"abc",
                                        @"language" : @"def",
                                        @"location" : @"50.500000,150.500000",
                                        @"offset" : @(100),
                                        @"radius" : @(1000),
                                        @"types" : @"(regions)"
                                    }];

                                });

                         });
             });

});

SPEC_END