//
//  HNKGooglePlacesAutocompleteQuerySpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/30/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteServer.h>

@interface HNKGooglePlacesAutocompleteQuery (KiwiExposedMethods)

@property (nonatomic, strong) NSString *apiKey;

@end

SPEC_BEGIN(HNKGooglePlacesAutocompleteQuerySpec)

__block HNKGooglePlacesAutocompleteQuery *testInstance;

beforeAll(^{

    testInstance = [HNKGooglePlacesAutocompleteQuery sharedQuery];

});

describe(@"HNKGooglePlacesAutocompleteQuery", ^{

    specify(^{

        [[testInstance should] beNonNil];

    });

    describe(
        @"Method: fetchPlacesForSearchQuery:completion:",
        ^{
            typedef void (^HNKGooglePlacesAutocompleteServerCallback)(id JSON, NSError *error);

            it(@"Should make a GET request to the Server",
               ^{
                   [[HNKGooglePlacesAutocompleteServer should]
                             receive:@selector(GET:parameters:completion:)
                       withArguments:@"place/autocomplete/json",
                                     @{
                                         @"input" : @"Vict",
                                         @"key" : @"AIzaSyAkR80JQgRgfnqBl6Db2RsnmkCG1LhuVn8",
                                         @"radius" : @500
                                     },
                                     any()];

                   [[HNKGooglePlacesAutocompleteQuery sharedQuery] fetchPlacesForSearchQuery:@"Vict" completion:nil];

               });

            context(
                @"JSON fetched successfully",
                ^{

                    beforeEach(^{

                        NSDictionary *testJSON = @{
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

                        [HNKGooglePlacesAutocompleteServer stub:@selector(GET:parameters:completion:)
                                                      withBlock:^id(NSArray *params) {

                                                          HNKGooglePlacesAutocompleteServerCallback completion =
                                                              params[2];
                                                          completion(testJSON, nil);

                                                          return nil;

                                                      }];

                    });

                    it(@"Should return Places",
                       ^{

                           __block HNKQueryResponsePrediction *testPlace;

                           [testInstance fetchPlacesForSearchQuery:@"Vict"
                                                        completion:^(NSArray *places, NSError *error) {
                                                            testPlace = places[0];
                                                        }];

                           [[testPlace.predictionDescription should] equal:@"Victoria, BC, Canadá"];

                           HNKQueryResponsePredictionMatchedSubstring *matchedSubstring =
                               testPlace.matchedSubstrings[0];
                           [[theValue(matchedSubstring.length) should] equal:theValue(4)];
                           [[theValue(matchedSubstring.offset) should] equal:theValue(0)];

                           [[testPlace.placeId should] equal:@"ChIJcWGw3Ytzj1QR7Ui7HnTz6Dg"];

                           HNKQueryResponsePredictionTerm *term1 = testPlace.terms[0];
                           HNKQueryResponsePredictionTerm *term2 = testPlace.terms[1];
                           HNKQueryResponsePredictionTerm *term3 = testPlace.terms[2];
                           [[theValue(term1.offset) should] equal:theValue(0)];
                           [[term1.value should] equal:@"Victoria"];
                           [[theValue(term2.offset) should] equal:theValue(10)];
                           [[term2.value should] equal:@"BC"];
                           [[theValue(term3.offset) should] equal:theValue(14)];
                           [[term3.value should] equal:@"Canadá"];

                           [[testPlace.types[0] should] equal:theValue(HNKGooglePlacesAutocompletePlaceTypeLocality)];
                           [[testPlace.types[1] should] equal:theValue(HNKGooglePlacesAutocompletePlaceTypePolitical)];
                           [[testPlace.types[2] should] equal:theValue(HNKGooglePlacesAutocompletePlaceTypeGeocode)];

                       });

                });

            context(
                @"Error during fetch",
                ^{

                    __block NSError *testError;

                    beforeEach(^{

                        testError = [NSError errorWithDomain:@"Test Domain" code:100 userInfo:@{ @"user" : @"info" }];

                        [HNKGooglePlacesAutocompleteServer stub:@selector(GET:parameters:completion:)
                                                      withBlock:^id(NSArray *params) {

                                                          HNKGooglePlacesAutocompleteServerCallback completion =
                                                              params[2];
                                                          completion(nil, testError);

                                                          return nil;

                                                      }];

                    });

                    it(@"Should return error",
                       ^{
                           __block NSError *errorToRecieve;

                           [testInstance fetchPlacesForSearchQuery:@"Vict"
                                                        completion:^(NSArray *places, NSError *error) {
                                                            errorToRecieve = error;
                                                        }];

                           [[errorToRecieve should] equal:testError];

                       });

                });

        });

});

SPEC_END