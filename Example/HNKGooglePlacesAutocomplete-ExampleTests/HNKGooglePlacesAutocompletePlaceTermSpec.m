//
//  HNKGooglePlacesAutocompletePlaceTermSpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

SPEC_BEGIN(HNKGooglePlacesAutocompletePlaceTermSpec)

__block HNKGooglePlacesAutocompletePlaceTerm *testInstance;
__block NSDictionary *json;

beforeAll(^{

    json = @{ @"offset" : @10, @"value" : @"BC" };

    testInstance = [HNKGooglePlacesAutocompletePlaceTerm modelFromJSONDictionary:json];

});

describe(@"HNKGooglePlacesAutocompletePlaceTerm", ^{

    specify(^{

        [[testInstance should] beNonNil];

    });

    describe(@"Deserialization",
             ^{

                 it(@"Should assign properties correctly",
                    ^{

                        [[theValue(testInstance.offset) should] equal:theValue(10)];
                        [[testInstance.value should] equal:@"BC"];

                    });

             });

});

SPEC_END