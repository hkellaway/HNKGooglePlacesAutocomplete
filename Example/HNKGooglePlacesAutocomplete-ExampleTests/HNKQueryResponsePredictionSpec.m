//
//  HNKQueryResponsePredictionSpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

SPEC_BEGIN(HNKQueryResponsePredictionSpec)

__block HNKQueryResponsePrediction *testInstance;
__block NSDictionary *json;

beforeAll(^{

    json = @{
        @"description" : @"Victoria, BC, Canadá",
        @"id" : @"d5892cffd777f0252b94ab2651fea7123d2aa34a",
        @"matched_substrings" : @[ @{@"length" : @4, @"offset" : @0} ],
        @"place_id" : @"ChIJcWGw3Ytzj1QR7Ui7HnTz6Dg",
        @"reference" : @"CjQtAAAA903zyJZAu2FLA6KkdC7UAddRHAfHQDpArCk61FI_"
        @"u1Ig7WaJqBiXYsQvORYMcgILEhAFvGtwa5VQpswubIIzwI5wGhTt8vgj6CSQp8QWYb4U1rXmlkg9bg",
        @"terms" : @[
            @{@"offset" : @0, @"value" : @"Victoria"},
            @{@"offset" : @10, @"value" : @"BC"},
            @{@"offset" : @14, @"value" : @"Canadá"}
        ],
        @"types" : @[ @"locality", @"political", @"geocode" ]
    };

    testInstance = [HNKQueryResponsePrediction modelFromJSONDictionary:json];

});

describe(@"HNKQueryResponsePredictionTerm", ^{

    specify(^{

        [[testInstance should] beNonNil];

    });

    describe(@"Deserialization",
             ^{

                 it(@"Should assign properties correctly",
                    ^{
                        [[testInstance.name should] equal:@"Victoria, BC, Canadá"];

                        HNKQueryResponsePredictionMatchedSubstring *matchedSubstring =
                            testInstance.matchedSubstrings[0];
                        [[theValue(matchedSubstring.length) should] equal:theValue(4)];
                        [[theValue(matchedSubstring.offset) should] equal:theValue(0)];

                        [[testInstance.placeId should] equal:@"ChIJcWGw3Ytzj1QR7Ui7HnTz6Dg"];

                        HNKQueryResponsePredictionTerm *term1 = testInstance.terms[0];
                        HNKQueryResponsePredictionTerm *term2 = testInstance.terms[1];
                        HNKQueryResponsePredictionTerm *term3 = testInstance.terms[2];
                        [[theValue(term1.offset) should] equal:theValue(0)];
                        [[term1.value should] equal:@"Victoria"];
                        [[theValue(term2.offset) should] equal:theValue(10)];
                        [[term2.value should] equal:@"BC"];
                        [[theValue(term3.offset) should] equal:theValue(14)];
                        [[term3.value should] equal:@"Canadá"];

                        [[testInstance.types[0] should] equal:theValue(HNKGooglePlacesAutocompletePlaceTypeLocality)];
                        [[testInstance.types[1] should] equal:theValue(HNKGooglePlacesAutocompletePlaceTypePolitical)];
                        [[testInstance.types[2] should] equal:theValue(HNKGooglePlacesAutocompletePlaceTypeGeocode)];

                    });

             });

});

SPEC_END