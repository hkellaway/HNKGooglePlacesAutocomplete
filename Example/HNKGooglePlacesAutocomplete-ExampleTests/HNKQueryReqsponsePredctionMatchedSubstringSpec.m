//
//  HNKQueryReqsponsePredctionMatchedSubstringSpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

SPEC_BEGIN(HNKQueryResponsePredictionMatchedSubstringSpec)

__block HNKQueryResponsePredictionMatchedSubstring *testInstance;
__block NSDictionary *json;

beforeAll(^{

    json = @{ @"length" : @4, @"offset" : @0 };

    testInstance = [HNKQueryResponsePredictionMatchedSubstring modelFromJSONDictionary:json];

});

describe(@"HNKQueryResponsePredictionMatchedSubstring", ^{

    specify(^{

        [[testInstance should] beNonNil];

    });

    describe(@"Deserialization",
             ^{

                 it(@"Should assign properties correctly",
                    ^{

                        [[theValue(testInstance.length) should] equal:theValue(4)];
                        [[theValue(testInstance.offset) should] equal:theValue(0)];

                    });

             });

});

SPEC_END