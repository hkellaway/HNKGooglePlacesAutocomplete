//
//  HNKGooglePlacesAutocompleteQueryResponseSpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

SPEC_BEGIN(HNKGooglePlacesAutocompleteQueryResponseSpec)

__block HNKGooglePlacesAutocompleteQueryResponse *testInstance;
__block NSDictionary *json;

beforeAll(^{

    json = @{
        @"predictions" : @[
            @{
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
            }
        ],
        @"status" : @"OK"
    };

    testInstance = [HNKGooglePlacesAutocompleteQueryResponse modelFromJSONDictionary:json];

});

describe(@"HNKGooglePlacesAutocompleteQueryResponse", ^{

    specify(^{

        [[testInstance should] beNonNil];

    });

    describe(@"Deserialization",
             ^{

                 it(@"Should assign properties correctly",
                    ^{
                        [[theValue(testInstance.status) should]
                            equal:theValue(HNKGooglePlacesAutocompleteQueryResponseStatusOK)];

                        HNKGooglePlacesAutocompletePlace *place = testInstance.places[0];
                        [[place.name should] equal:@"Victoria, BC, Canadá"];

                        HNKGooglePlacesAutocompletePlaceSubstring *substring = place.substrings[0];
                        [[theValue(substring.length) should] equal:theValue(4)];
                        [[theValue(substring.offset) should] equal:theValue(0)];

                        [[place.placeId should] equal:@"ChIJcWGw3Ytzj1QR7Ui7HnTz6Dg"];

                        HNKGooglePlacesAutocompletePlaceTerm *term1 = place.terms[0];
                        HNKGooglePlacesAutocompletePlaceTerm *term2 = place.terms[1];
                        HNKGooglePlacesAutocompletePlaceTerm *term3 = place.terms[2];
                        [[theValue(term1.offset) should] equal:theValue(0)];
                        [[term1.value should] equal:@"Victoria"];
                        [[theValue(term2.offset) should] equal:theValue(10)];
                        [[term2.value should] equal:@"BC"];
                        [[theValue(term3.offset) should] equal:theValue(14)];
                        [[term3.value should] equal:@"Canadá"];

                        [[place.types[0] should] equal:theValue(HNKGooglePlaceTypeLocality)];
                        [[place.types[1] should] equal:theValue(HNKGooglePlaceTypePolitical)];
                        [[place.types[2] should] equal:theValue(HNKGooglePlaceTypeGeocode)];

                    });

             });

});

SPEC_END