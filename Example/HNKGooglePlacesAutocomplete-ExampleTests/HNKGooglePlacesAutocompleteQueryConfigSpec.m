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

    describe(
        @"Method: initWithCountry:filter:language:location:offset:searchRadius:",
        ^{

            it(@"Should set properties correctly",
               ^{

                   HNKGooglePlacesAutocompleteQueryConfig *testInstance =
                       [[HNKGooglePlacesAutocompleteQueryConfig alloc]
                           initWithCountry:@"abc"
                                    filter:HNKGooglePlaceTypeAutocompleteFilterRegion
                                  language:@"def"
                                  latitude:50.5
                                 longitude:150.5
                                    offset:100
                              searchRadius:1000];

                   [[testInstance.country should] equal:@"abc"];
                   [[theValue(testInstance.filter) should] equal:theValue(HNKGooglePlaceTypeAutocompleteFilterRegion)];
                   [[testInstance.language should] equal:@"def"];
                   [[theValue(testInstance.latitude) should] equal:theValue(50.5)];
                   [[theValue(testInstance.longitude) should] equal:theValue(150.5)];
                   [[theValue(testInstance.offset) should] equal:theValue(100)];
                   [[theValue(testInstance.searchRadius) should] equal:theValue(1000)];

               });

        });

    describe(@"translateToServerRequestParameters",
             ^{

                 it(@"Should return correct dictionary",
                    ^{

                        HNKGooglePlacesAutocompleteQueryConfig *testInstance =
                            [[HNKGooglePlacesAutocompleteQueryConfig alloc]
                                initWithCountry:nil
                                         filter:HNKGooglePlaceTypeAutocompleteFilterAll
                                       language:nil
                                       latitude:50.5
                                      longitude:150.5
                                         offset:NSNotFound
                                   searchRadius:NSNotFound];

                        NSDictionary *params = [testInstance translateToServerRequestParameters];

                        [[params should] equal:@{ @"location" : @"50.500000,150.500000" }];

                        testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc]
                            initWithCountry:@"abc"
                                     filter:HNKGooglePlaceTypeAutocompleteFilterAll
                                   language:@"def"
                                   latitude:50.5
                                  longitude:150.5
                                     offset:NSNotFound
                               searchRadius:NSNotFound];

                        params = [testInstance translateToServerRequestParameters];

                        [[params should] equal:@{
                            @"components=country" : @"abc",
                            @"language" : @"def",
                            @"location" : @"50.500000,150.500000"
                        }];

                        testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc]
                            initWithCountry:@"abc"
                                     filter:HNKGooglePlaceTypeAutocompleteFilterAll
                                   language:@"def"
                                   latitude:50.5
                                  longitude:150.5
                                     offset:100
                               searchRadius:1000];

                        params = [testInstance translateToServerRequestParameters];

                        [[params should] equal:@{
                            @"components=country" : @"abc",
                            @"language" : @"def",
                            @"location" : @"50.500000,150.500000",
                            @"offset" : @(100),
                            @"radius" : @(1000)
                        }];

                        testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc]
                            initWithCountry:@"abc"
                                     filter:HNKGooglePlaceTypeAutocompleteFilterRegion
                                   language:@"def"
                                   latitude:50.5
                                  longitude:150.5
                                     offset:100
                               searchRadius:1000];

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

SPEC_END