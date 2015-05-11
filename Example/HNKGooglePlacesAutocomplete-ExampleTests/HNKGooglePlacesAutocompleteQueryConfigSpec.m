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

__block struct HNKGooglePlacesAutocompleteLocation testLocation;

beforeAll(^{
    
    testLocation.latitude = 50.0;
    testLocation.longitude = 150.0;
    
});

describe(@"HNKGooglePlacesAutocompleteQueryConfig", ^{
    
    describe(@"Method: initWithCountry:filter:language:location:offset:searchRadius:", ^{
        
        it(@"Should set properties correctly", ^{
            
            HNKGooglePlacesAutocompleteQueryConfig *testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc] initWithCountry:@"abc" filter:HNKGooglePlaceTypeAutocompleteFilterRegion language:@"def" location:testLocation offset:100 searchRadius:1000];
            
            [[testInstance.country should] equal:@"abc"];
            [[theValue(testInstance.filter) should] equal:theValue(HNKGooglePlaceTypeAutocompleteFilterRegion)];
            [[testInstance.language should] equal:@"def"];
            [[theValue(testInstance.location.latitude) should] equal:theValue(50.0)];
            [[theValue(testInstance.location.longitude) should] equal:theValue(150.0)];
            [[theValue(testInstance.offset) should] equal:theValue(100)];
            [[theValue(testInstance.searchRadius) should] equal:theValue(1000)];
            
        });
        
    });
    
    describe(@"translateToServerRequestParameters", ^{
        
            it(@"Should return correct dictionary", ^{
                
                HNKGooglePlacesAutocompleteQueryConfig *testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc] initWithCountry:nil filter:HNKGooglePlaceTypeAutocompleteFilterAll language:nil location:testLocation offset:NSNotFound searchRadius:NSNotFound];

                NSDictionary *params = [testInstance translateToServerRequestParameters];
                
                [[params should] equal:@{
                                         @"location" : @"50.000000,150.000000"
                                         }];
                
                testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc] initWithCountry:@"abc" filter:HNKGooglePlaceTypeAutocompleteFilterAll language:@"def" location:testLocation offset:NSNotFound searchRadius:NSNotFound];
                
                params = [testInstance translateToServerRequestParameters];
                
                [[params should] equal:@{
                                         @"components=country" : @"abc",
                                         @"language" : @"def",
                                         @"location" : @"50.000000,150.000000"
                                         }];
                
                testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc] initWithCountry:@"abc" filter:HNKGooglePlaceTypeAutocompleteFilterAll language:@"def" location:testLocation offset:100 searchRadius:1000];
                
                params = [testInstance translateToServerRequestParameters];
                
                [[params should] equal:@{
                                         @"components=country" : @"abc",
                                         @"language" : @"def",
                                         @"location" : @"50.000000,150.000000",
                                         @"offset" : @(100),
                                         @"radius" : @(1000)
                                         }];
                
                testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc] initWithCountry:@"abc" filter:HNKGooglePlaceTypeAutocompleteFilterRegion language:@"def" location:testLocation offset:100 searchRadius:1000];
                
                params = [testInstance translateToServerRequestParameters];
                
                [[params should] equal:@{
                                         @"components=country" : @"abc",
                                         @"language" : @"def",
                                         @"location" : @"50.000000,150.000000",
                                         @"offset" : @(100),
                                         @"radius" : @(1000),
                                         @"types" : @"(regions)"
                                         }];
                
            });
        
    });
    
});

SPEC_END