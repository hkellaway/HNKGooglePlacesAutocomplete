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

    describe(@"configWithConfig", ^{
        
        __block HNKGooglePlacesAutocompleteQueryConfig *testInstance;
        
        beforeEach(^{
            
            HNKGooglePlacesAutocompleteQueryConfig *testConfig = [[HNKGooglePlacesAutocompleteQueryConfig alloc] init];
            testConfig.country = @"fr";
            testConfig.filter = HNKGooglePlaceTypeAutocompleteFilterCity;
            testConfig.language = @"pt";
            testConfig.latitude = 100;
            testConfig.longitude = 50;
            testConfig.offset = 3;
            testConfig.searchRadius = 100000;
            
            testInstance = [HNKGooglePlacesAutocompleteQueryConfig configWithConfig:testConfig];
            
        });
        
        it(@"Should return a new config with same config values", ^{
        
            [[testInstance.country should] equal:@"fr"];
            [[theValue(testInstance.filter) should] equal:theValue(HNKGooglePlaceTypeAutocompleteFilterCity)];
            [[testInstance.language should] equal:@"pt"];
            [[theValue(testInstance.latitude) should] equal:theValue(100)];
            [[theValue(testInstance.longitude) should] equal:theValue(50)];
            [[theValue(testInstance.offset) should] equal:theValue(3)];
            [[theValue(testInstance.searchRadius) should] equal:theValue(100000)];
        
        });
    });
    
    describe(@"defaultConfig", ^{
        
        it(@"Should have default config values", ^{
            
            HNKGooglePlacesAutocompleteQueryConfig *defaultConfig = [HNKGooglePlacesAutocompleteQueryConfig defaultConfig];
            
            [[defaultConfig.country should] beNil];
            [[theValue(defaultConfig.filter) should] equal:theValue(HNKGooglePlaceTypeAutocompleteFilterAll)];
            [[defaultConfig.language should] beNil];
            [[theValue(defaultConfig.latitude) should] equal:theValue(0)];
            [[theValue(defaultConfig.longitude) should] equal:theValue(0)];
            [[theValue(defaultConfig.offset) should] equal:theValue(NSNotFound)];
            [[theValue(defaultConfig.searchRadius) should] equal:theValue(20000000)];
            
        });
        
    });
    
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
                                        @"components" : @"country:abc",
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
                                        @"components" : @"country:abc",
                                        @"language" : @"def",
                                        @"location" : @"50.500000,150.500000"
                                    }];

                                    testInstance.offset = 100;
                                    testInstance.searchRadius = 1000;

                                    params = [testInstance translateToServerRequestParameters];

                                    [[params should] equal:@{
                                        @"components" : @"country:abc",
                                        @"language" : @"def",
                                        @"location" : @"50.500000,150.500000",
                                        @"offset" : @(100),
                                        @"radius" : @(1000)
                                    }];

                                    testInstance.filter = HNKGooglePlaceTypeAutocompleteFilterRegion;

                                    params = [testInstance translateToServerRequestParameters];

                                    [[params should] equal:@{
                                        @"components" : @"country:abc",
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