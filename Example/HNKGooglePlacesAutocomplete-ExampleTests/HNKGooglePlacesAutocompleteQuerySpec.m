//
//  HNKGooglePlacesAutocompleteQuerySpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/30/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesServer.h>

@interface HNKGooglePlacesAutocompleteQuery (KiwiExposedMethods)

- (instancetype)initWithAPIKey:(NSString *)apiKey
            configurationBlock:(void (^)(HNKGooglePlacesAutocompleteQueryConfig *))configBlock;

@end

SPEC_BEGIN(HNKGooglePlacesAutocompleteQuerySpec)

__block HNKGooglePlacesAutocompleteQuery *testInstance;
__block HNKGooglePlacesAutocompleteQuery *testInstanceWithNoConfig;

beforeAll(^{

    testInstance =
        [[HNKGooglePlacesAutocompleteQuery alloc] initWithAPIKey:@"abc"
                                              configurationBlock:^(HNKGooglePlacesAutocompleteQueryConfig *config) {

                                                  config.country = @"fr";
                                                  config.filter = HNKGooglePlaceTypeAutocompleteFilterCity;
                                                  config.language = @"pt_BR";
                                                  config.latitude = 50.0;
                                                  config.longitude = 150.0;
                                                  config.offset = 50;
                                                  config.searchRadius = 100;

                                              }];

    testInstanceWithNoConfig = [[HNKGooglePlacesAutocompleteQuery alloc] initWithAPIKey:@"def" configurationBlock:nil];

});

describe(@"HNKGooglePlacesAutocompleteQuery", ^{

    describe(
        @"Method: defaultConfiguration",
        ^{

            context(
                @"No default configuration provided",
                ^{

                    __block HNKGooglePlacesAutocompleteQuery *testInstanceNoConfig;

                    beforeEach(^{

                        testInstanceNoConfig =
                            [[HNKGooglePlacesAutocompleteQuery alloc] initWithAPIKey:@"abc" configurationBlock:nil];

                    });

                    it(@"Should return default configuration",
                       ^{

                           HNKGooglePlacesAutocompleteQueryConfig *config = [testInstanceNoConfig configuration];

                           [[theValue(config.searchRadius) should] equal:theValue(20000000)];
                           [[theValue(config.filter) should] equal:theValue(HNKGooglePlaceTypeAutocompleteFilterAll)];

                       });

                });

            context(
                @"Default configuration provided",
                ^{

                    it(@"Should return custom configuration",
                       ^{

                           HNKGooglePlacesAutocompleteQueryConfig *config = [testInstance configuration];

                           [[theValue(config.searchRadius) should] equal:theValue(100)];
                           [[theValue(config.filter) should] equal:theValue(HNKGooglePlaceTypeAutocompleteFilterCity)];

                       });

                });

        });

    describe(
        @"Method: fetchPlacesForSearchQuery:configurationBlock:completion:",
        ^{
            typedef void (^HNKGooglePlacesServerCallback)(id JSON, NSError *error);

            it(@"Should make a GET request to the Server",
               ^{
                   [[HNKGooglePlacesServer should] receive:@selector(GET:parameters:completion:)
                                             withArguments:@"autocomplete/json", any(), any()];

                   [testInstance fetchPlacesForSearchQuery:@"Vict" configurationBlock:nil completion:nil];

               });

            context(@"No configuration provided",
                    ^{

                        it(@"Should use default configuration",
                           ^{

                               [[HNKGooglePlacesServer should] receive:@selector(GET:parameters:completion:)
                                                         withArguments:@"autocomplete/json",
                                                                       @{
                                                                           @"input" : @"Vict",
                                                                           @"key" : testInstanceWithNoConfig.apiKey,
                                                                           @"radius" : @(20000000)
                                                                       },
                                                                       any()];

                               [testInstanceWithNoConfig fetchPlacesForSearchQuery:@"Vict"
                                                                configurationBlock:nil
                                                                        completion:nil];

                           });

                    });

            context(
                @"Configuration provided",
                ^{

                    it(@"Should use custom configuration",
                       ^{

                           [[HNKGooglePlacesServer should] receive:@selector(GET:parameters:completion:)
                                                     withArguments:@"autocomplete/json",
                                                                   @{
                                                                       @"components=country" : @"fr",
                                                                       @"input" : @"Vict",
                                                                       @"key" : testInstance.apiKey,
                                                                       @"language" : @"pt_BR",
                                                                       @"location" : @"50.000000,150.000000",
                                                                       @"offset" : @(50),
                                                                       @"radius" : @(100),
                                                                       @"types" : @"(cities)"
                                                                   },
                                                                   any()];

                           [testInstance fetchPlacesForSearchQuery:@"Vict"
                                                configurationBlock:^(HNKGooglePlacesAutocompleteQueryConfig *config) {

                                                    config.country = @"fr";
                                                    config.filter = HNKGooglePlaceTypeAutocompleteFilterCity;
                                                    config.language = @"pt_BR";
                                                    config.latitude = 50;
                                                    config.longitude = 150;
                                                    config.offset = 50;
                                                    config.searchRadius = 100;

                                                } completion:nil];

                       });

                });

            context(
                @"Invalid search query",
                ^{
                    context(@"Empty string",
                            ^{

                                it(@"Should return custom error",
                                   ^{

                                       __block NSError *errorToRecieve;
                                       NSError *expectedError = [NSError
                                           errorWithDomain:HNKGooglePlacesAutocompleteQueryErrorDomain
                                                      code:HNKGooglePlacesAutocompleteQueryResponseStatusInvalidRequest
                                                  userInfo:@{
                                                      @"NSLocalizedDescription" :
                                                          HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(
                                                              HNKGooglePlacesAutocompleteQueryErrorCodeInvalidRequest),
                                                      @"NSLocalizedFailureReasonError" :
                                                          HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(
                                                              HNKGooglePlacesAutocompleteQueryErrorCodeInvalidRequest)
                                                  }];

                                       [testInstance fetchPlacesForSearchQuery:@""
                                                                    completion:^(NSArray *places, NSError *error) {
                                                                        errorToRecieve = error;
                                                                    }];

                                       [[errorToRecieve should] equal:expectedError];
                                   });

                            });

                    context(@"nil",
                            ^{
                                it(@"Should return custom error",
                                   ^{

                                       __block NSError *errorToRecieve;
                                       NSError *expectedError = [NSError
                                           errorWithDomain:HNKGooglePlacesAutocompleteQueryErrorDomain
                                                      code:HNKGooglePlacesAutocompleteQueryErrorCodeSearchQueryNil
                                                  userInfo:@{
                                                      @"NSLocalizedDescription" :
                                                          HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(
                                                              HNKGooglePlacesAutocompleteQueryErrorCodeSearchQueryNil),
                                                      @"NSLocalizedFailureReasonError" :
                                                          HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(
                                                              HNKGooglePlacesAutocompleteQueryErrorCodeSearchQueryNil)
                                                  }];

                                       [testInstance fetchPlacesForSearchQuery:nil
                                                                    completion:^(NSArray *places, NSError *error) {
                                                                        errorToRecieve = error;
                                                                    }];

                                       [[errorToRecieve should] equal:expectedError];
                                   });

                            });
                });

            context(
                @"Valid search query",
                ^{
                    context(
                        @"JSON fetched successfully",
                        ^{

                            context(
                                @"With good status code",
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
                                                   @"u1Ig7WaJqBiXYsQvORYMcgILEhAFvGtwa5VQpswubIIzwI5wGhTt8vgj6CSQp8QWYb"
                                                   @"4U1rXmlk" @"g9bg",
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

                                        [HNKGooglePlacesServer stub:@selector(GET:parameters:completion:)
                                                          withBlock:^id(NSArray *params) {

                                                              HNKGooglePlacesServerCallback completion = params[2];
                                                              completion(testJSON, nil);

                                                              return nil;

                                                          }];

                                    });

                                    it(@"Should return Places",
                                       ^{

                                           __block HNKGooglePlacesAutocompletePlace *testPlace;

                                           [testInstance fetchPlacesForSearchQuery:@"Vict"
                                                                        completion:^(NSArray *places, NSError *error) {
                                                                            testPlace = places[0];
                                                                        }];

                                           [[testPlace.name should] equal:@"Victoria, BC, Canadá"];

                                           HNKGooglePlacesAutocompletePlaceSubstring *substring =
                                               testPlace.substrings[0];
                                           [[theValue(substring.length) should] equal:theValue(4)];
                                           [[theValue(substring.offset) should] equal:theValue(0)];

                                           [[testPlace.placeId should] equal:@"ChIJcWGw3Ytzj1QR7Ui7HnTz6Dg"];

                                           HNKGooglePlacesAutocompletePlaceTerm *term1 = testPlace.terms[0];
                                           HNKGooglePlacesAutocompletePlaceTerm *term2 = testPlace.terms[1];
                                           HNKGooglePlacesAutocompletePlaceTerm *term3 = testPlace.terms[2];
                                           [[theValue(term1.offset) should] equal:theValue(0)];
                                           [[term1.value should] equal:@"Victoria"];
                                           [[theValue(term2.offset) should] equal:theValue(10)];
                                           [[term2.value should] equal:@"BC"];
                                           [[theValue(term3.offset) should] equal:theValue(14)];
                                           [[term3.value should] equal:@"Canadá"];

                                           [[testPlace.types[0] should] equal:theValue(HNKGooglePlaceTypeLocality)];
                                           [[testPlace.types[1] should] equal:theValue(HNKGooglePlaceTypePolitical)];
                                           [[testPlace.types[2] should] equal:theValue(HNKGooglePlaceTypeGeocode)];

                                       });
                                });

                            context(
                                @"With bad status code",
                                ^{
                                    beforeEach(^{

                                        NSDictionary *statusErrorJSON =
                                            @{ @"predictions" : @[],
                                               @"status" : @"REQUEST_DENIED" };

                                        [HNKGooglePlacesServer stub:@selector(GET:parameters:completion:)
                                                          withBlock:^id(NSArray *params) {

                                                              HNKGooglePlacesServerCallback completion = params[2];
                                                              completion(statusErrorJSON, nil);

                                                              return nil;

                                                          }];

                                    });

                                    it(@"Should return custom error",
                                       ^{
                                           __block NSError *errorToRecieve;
                                           NSError *expectedError = [NSError
                                               errorWithDomain:HNKGooglePlacesAutocompleteQueryErrorDomain
                                                          code:
                                                              HNKGooglePlacesAutocompleteQueryResponseStatusRequestDenied
                                                      userInfo:@{
                                                          @"NSLocalizedDescription" :
                                                              HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(
                                                                  HNKGooglePlacesAutocompleteQueryErrorCodeRequestDenied),
                                                          @"NSLocalizedFailureReasonError" :
                                                              HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(
                                                                  HNKGooglePlacesAutocompleteQueryErrorCodeRequestDenied)
                                                      }];

                                           [testInstance fetchPlacesForSearchQuery:@"Vict"
                                                                        completion:^(NSArray *places, NSError *error) {
                                                                            errorToRecieve = error;
                                                                        }];

                                           [[errorToRecieve should] equal:expectedError];

                                       });

                                });
                        });

                    context(
                        @"Error during fetch",
                        ^{
                            __block NSError *testError;

                            beforeEach(^{

                                testError =
                                    [NSError errorWithDomain:@"Test Domain" code:100 userInfo:@{
                                        @"user" : @"info"
                                    }];

                                [HNKGooglePlacesServer stub:@selector(GET:parameters:completion:)
                                                  withBlock:^id(NSArray *params) {

                                                      HNKGooglePlacesServerCallback completion = params[2];
                                                      completion(nil, testError);

                                                      return nil;

                                                  }];

                            });

                            it(@"Should return custom error with orignal error documented",
                               ^{
                                   __block NSError *errorToRecieve;
                                   NSError *expectedError = [NSError
                                       errorWithDomain:HNKGooglePlacesAutocompleteQueryErrorDomain
                                                  code:HNKGooglePlacesAutcompleteQueryErrorCodeServerRequestFailed
                                              userInfo:@{
                                                  @"NSUnderlyingError" : testError,
                                                  @"NSLocalizedDescription" :
                                                      HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(
                                                          HNKGooglePlacesAutcompleteQueryErrorCodeServerRequestFailed),
                                                  @"NSLocalizedFailureReasonError" :
                                                      HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(
                                                          HNKGooglePlacesAutcompleteQueryErrorCodeServerRequestFailed)
                                              }];

                                   [testInstance fetchPlacesForSearchQuery:@"Vict"
                                                                completion:^(NSArray *places, NSError *error) {
                                                                    errorToRecieve = error;
                                                                }];

                                   [[errorToRecieve should] equal:expectedError];

                               });

                        });
                });

            describe(
                @"Method: fetchPlacesForSearchQuery:completion:",
                ^{

                    it(@"Should call designated fetchPlaces",
                       ^{

                           [[testInstance should]
                               receive:@selector(fetchPlacesForSearchQuery:configurationBlock:completion:)];

                           [testInstance fetchPlacesForSearchQuery:@"Vict" completion:nil];

                       });

                    context(
                        @"Configuration provided in setup",
                        ^{

                            it(@"Should use default configuration",
                               ^{

                                   [[HNKGooglePlacesServer should] receive:@selector(GET:parameters:completion:)
                                                             withArguments:@"autocomplete/json",
                                                                           @{
                                                                               @"components=country" : @"fr",
                                                                               @"input" : @"Vict",
                                                                               @"key" : testInstance.apiKey,
                                                                               @"language" : @"pt_BR",
                                                                               @"location" : @"50.000000,150.000000",
                                                                               @"offset" : @(50),
                                                                               @"radius" : @(100),
                                                                               @"types" : @"(cities)"
                                                                           },
                                                                           any()];

                                   [testInstance fetchPlacesForSearchQuery:@"Vict" completion:nil];

                               });

                        });

                    context(
                        @"Configuration not provided in setup",
                        ^{

                            it(@"Should use default configuration",
                               ^{

                                   [[HNKGooglePlacesServer should] receive:@selector(GET:parameters:completion:)
                                                             withArguments:@"autocomplete/json",
                                                                           @{
                                                                               @"input" : @"Vict",
                                                                               @"key" : testInstanceWithNoConfig.apiKey,
                                                                               @"radius" : @(20000000)
                                                                           },
                                                                           any()];

                                   [testInstanceWithNoConfig fetchPlacesForSearchQuery:@"Vict" completion:nil];

                               });

                        });

                });

        });

});

SPEC_END