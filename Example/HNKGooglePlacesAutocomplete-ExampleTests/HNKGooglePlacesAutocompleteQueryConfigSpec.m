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
    
    describe(@"translateToServerRequestParameters", ^{
        
        context(@"No properties set", ^{
            
            __block HNKGooglePlacesAutocompleteQueryConfig *testInstance;
            
            beforeEach(^{
            
                testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc] init];
                
            });
            
            it(@"Should return nil", ^{
                
                NSDictionary *params = [testInstance translateToServerRequestParameters];
                
                [[params should] equal:nil];
                
            });
            
        });
        
        context(@"Properties set", ^{
            
            __block HNKGooglePlacesAutocompleteQueryConfig *testInstance;
            
            beforeEach(^{
                
                testInstance = [[HNKGooglePlacesAutocompleteQueryConfig alloc] init];
                
            });
            
            it(@"Should return correct dictionary", ^{
                
                struct HNKGooglePlacesAutocompleteLocation location;
                location.latitude = 50.0;
                location.longitude = 150.0;
                
                testInstance.country = @"abc";
                testInstance.language = @"def";
                testInstance.location = location;
                testInstance.offset = 100;
                testInstance.searchRadius = 1000;
                testInstance.types = @[ @(HNKGooglePlaceTypeColloquialArea) ];
                
                NSDictionary *params = [testInstance translateToServerRequestParameters];
                
                [[params should] equal:@{
                                         @"components=country" : @"abc",
                                         @"language" : @"def",
                                         @"location" : @"50.000000,150.000000",
                                         @"offset" : @(100),
                                         @"radius" : @(1000)
                                         }];
                
            });
            
        });
        
    });
    
});

SPEC_END