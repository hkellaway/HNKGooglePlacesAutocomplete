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

                 context(@"Latitude or longitude set to NSNotFound",
                         ^{
                             __block HNKGooglePlacesAutocompleteQueryConfig *testInstanceNoLat;
                             __block HNKGooglePlacesAutocompleteQueryConfig *testInstanceNoLon;

                             beforeEach(^{

                                 testInstanceNoLat = [[HNKGooglePlacesAutocompleteQueryConfig alloc] init];
                                 testInstanceNoLat.country = @"abc";
                                 testInstanceNoLat.filter = HNKGooglePlaceTypeAutocompleteFilterRegion;
                                 testInstanceNoLat.language = @"def";
                                 testInstanceNoLat.latitude = NSNotFound;
                                 testInstanceNoLat.longitude = 150.5;
                                 testInstanceNoLat.offset = 100;
                                 testInstanceNoLat.searchRadius = 1000;

                                 testInstanceNoLon = [[HNKGooglePlacesAutocompleteQueryConfig alloc] init];
                                 testInstanceNoLon.country = @"abc";
                                 testInstanceNoLon.filter = HNKGooglePlaceTypeAutocompleteFilterRegion;
                                 testInstanceNoLon.language = @"def";
                                 testInstanceNoLon.latitude = 50.5;
                                 testInstanceNoLon.longitude = NSNotFound;
                                 testInstanceNoLon.offset = 100;
                                 testInstanceNoLon.searchRadius = 1000;

                             });

                             it(@"Should not include location in parameters",
                                ^{
                                    NSDictionary *params = [testInstanceNoLat translateToServerRequestParameters];

                                    [[params should] equal:@{
                                        @"components=country" : @"abc",
                                        @"language" : @"def",
                                        @"offset" : @(100),
                                        @"radius" : @(1000),
                                        @"types" : @"(regions)"
                                    }];

                                    params = [testInstanceNoLon translateToServerRequestParameters];

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
                                    testInstance.latitude = NSNotFound;
                                    testInstance.longitude = NSNotFound;
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