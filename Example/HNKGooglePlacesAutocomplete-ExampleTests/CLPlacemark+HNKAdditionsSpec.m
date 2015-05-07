//
//  CLPlacemark+HNKAdditionsSpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 5/2/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <CoreLocation/CLPlacemark.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteServer.h>

#import "CLPlacemark+HNKAdditions.h"

@interface CLPlacemark (KiwiExtensions)

+ (BOOL)isGeocodeResult:(HNKQueryResponsePrediction *)place;

@end

SPEC_BEGIN(CLPlacemark_HNKAdditionsSpec)

describe(@"CLPlacemark+HNKAdditions", ^{

    describe(@"Method: isGeocodeResult",
             ^{

                 __block HNKQueryResponsePrediction *geocodeResultPlace;
                 __block HNKQueryResponsePrediction *nonGeocodeResultPlace;

                 beforeEach(^{

                     NSDictionary *geocodeResultJSON = @{
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

                     NSDictionary *nonGeocodeResultJSON = @{
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
                         @"types" : @[ @"establishment" ]
                     };
                     ;

                     geocodeResultPlace = [HNKQueryResponsePrediction modelFromJSONDictionary:geocodeResultJSON];
                     nonGeocodeResultPlace = [HNKQueryResponsePrediction modelFromJSONDictionary:nonGeocodeResultJSON];

                 });

                 context(@"Place is a geocode result",
                         ^{

                             it(@"Should return YES",
                                ^{
                                    BOOL isGeocode = [CLPlacemark isGeocodeResult:geocodeResultPlace];

                                    [[theValue(isGeocode) should] equal:theValue(YES)];

                                });

                         });

                 context(@"Place is not a geocode result",
                         ^{

                             it(@"Should return NO",
                                ^{
                                    BOOL isGeocode = [CLPlacemark isGeocodeResult:nonGeocodeResultPlace];

                                    [[theValue(isGeocode) should] equal:theValue(NO)];

                                });

                         });

             });

    describe(
        @"Method: placemarkFromGooglePlace:completion:",
        ^{
            typedef void (^HNKGooglePlacesAutocompleteServerCallback)(id responseObject, NSError *error);
            typedef void (^CLGeocoderGeocodeAddressCallback)(NSArray *placemarks, NSError *error);
            typedef void (^CLPlacemarkResolveToGooglePlaceCallback)(CLPlacemark *, NSString *, NSError *);

            __block NSString *testPlaceId;
            __block HNKQueryResponsePrediction *mockPlace;
            __block id mockGeocoder;
            __block NSString *testApiKey;
            __block NSDictionary *testDetailsJSON;

            beforeEach(^{

                testPlaceId = @"ChIJcWGw3Ytzj1QR7Ui7HnTz6Dg";
                mockPlace = [HNKQueryResponsePrediction nullMock];
                [mockPlace stub:@selector(name) andReturn:@"123 XYZ St, New York, NY, USA"];
                [mockPlace stub:@selector(placeId) andReturn:testPlaceId];

                mockGeocoder = [CLGeocoder nullMock];
                [CLGeocoder stub:@selector(alloc) andReturn:mockGeocoder];

                testApiKey = @"xyz";

                testDetailsJSON = @{
                    @"html_attributions" : @[],
                    @"result" : @{
                        @"address_components" : @[],
                        @"adr_address" : @"",
                        @"formatted_address" : @"Victoria, BC, Canada",
                        @"geometry" : @{
                            @"location" : @{@"lat" : @48.4284207, @"lng" : @-123.3656444},
                            @"viewport" : @{
                                @"northeast" : @{@"lat" : @48.450518, @"lng" : @-123.322346},
                                @"southwest" : @{@"lat" : @48.4028414, @"lng" : @-123.394489}
                            }
                        },
                        @"icon" : @"http://maps.gstatic.com/mapfiles/place_api/icons/geocode-71.png",
                        @"id" : @"d5892cffd777f0252b94ab2651fea7123d2aa34a",
                        @"name" : @"Victoria",
                        @"place_id" : testPlaceId,
                        @"reference" : @"",
                        @"scope" : @"GOOGLE",
                        @"types" : @[ @"locality", @"political" ],
                        @"url" : @"https://maps.google.com/maps/"
                        @"place?q=Victoria,+BC,+Canada&ftid=0x548f738bddb06171:" @"0x38e8f3741ebb48ed",
                        @"vicinity" : @"Victoria"
                    },
                    @"status" : @"OK"
                };

                [HNKGooglePlacesAutocompleteServer stub:@selector(GET:parameters:completion:)
                                              withBlock:^id(NSArray *params) {

                                                  HNKGooglePlacesAutocompleteServerCallback completion = params[2];
                                                  completion(testDetailsJSON, nil);

                                                  return nil;

                                              }];

            });

            context(@"Place is a geocode result",
                    ^{

                        beforeEach(^{

                            [CLPlacemark stub:@selector(isGeocodeResult:) andReturn:theValue(YES)];

                        });

                        it(@"Should not make server request",
                           ^{

                               [[HNKGooglePlacesAutocompleteServer shouldNot]
                                   receive:@selector(GET:parameters:completion:)];

                               [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace apiKey:testApiKey completion:nil];

                           });

                        it(@"Should call Geocoder with Place's name",
                           ^{
                               [[mockGeocoder should] receive:@selector(geocodeAddressString:completionHandler:)
                                                withArguments:mockPlace.name, any()];

                               [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace apiKey:testApiKey completion:nil];
                           });

                    });

            context(
                @"Place is not a geocode result",
                ^{

                    beforeEach(^{

                        [CLPlacemark stub:@selector(isGeocodeResult:) andReturn:theValue(NO)];

                    });

                    it(@"Should make server request",
                       ^{

                           [[HNKGooglePlacesAutocompleteServer should]
                                     receive:@selector(GET:parameters:completion:)
                               withArguments:@"place/details/json",
                                             @{ @"placeid" : testPlaceId,
                                                @"key" : testApiKey },
                                             any()];

                           [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace apiKey:testApiKey completion:nil];

                       });

                    context(
                        @"Fetching Place Details successful",
                        ^{

                            beforeEach(^{

                                [HNKGooglePlacesAutocompleteServer stub:@selector(GET:parameters:completion:)
                                                              withBlock:^id(NSArray *params) {

                                                                  HNKGooglePlacesAutocompleteServerCallback completion =
                                                                      params[2];
                                                                  completion(testDetailsJSON, nil);

                                                                  return nil;

                                                              }];

                            });

                            it(@"Should call Geocoder with Place formatted address",
                               ^{
                                   [[mockGeocoder should] receive:@selector(geocodeAddressString:completionHandler:)
                                                    withArguments:@"Victoria, BC, Canada", any()];

                                   [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace
                                                                      apiKey:testApiKey
                                                                  completion:nil];
                               });

                            context(@"Geocoder returns error",
                                    ^{

                                        beforeEach(^{

                                            [mockGeocoder stub:@selector(geocodeAddressString:completionHandler:)
                                                     withBlock:^id(NSArray *params) {

                                                         NSError *testError = [NSError errorWithDomain:@"Test Domain"
                                                                                                  code:-1
                                                                                              userInfo:@{
                                                                                                  @"user" : @"info"
                                                                                              }];

                                                         CLGeocoderGeocodeAddressCallback completionHandler = params[1];
                                                         completionHandler(nil, testError);

                                                         return nil;
                                                     }];

                                        });

                                        it(@"Should call Geocoder with Place's name",
                                           ^{
                                               [[mockGeocoder should]
                                                         receive:@selector(geocodeAddressString:completionHandler:)
                                                   withArguments:mockPlace.name, any()];

                                               [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace
                                                                                  apiKey:testApiKey
                                                                              completion:^(CLPlacemark *placemark,
                                                                                           NSString *addressString,
                                                                                           NSError *error){
                                                                              }];

                                           });

                                    });

                            context(
                                @"Geocoder successful",
                                ^{

                                    context(
                                        @"Less than one placemark returned by geocoder",
                                        ^{

                                            beforeEach(^{

                                                [mockGeocoder stub:@selector(geocodeAddressString:completionHandler:)
                                                         withBlock:^id(NSArray *params) {

                                                             CLGeocoderGeocodeAddressCallback completionHandler =
                                                                 params[1];
                                                             completionHandler(@[], nil);

                                                             return nil;
                                                         }];

                                            });

                                            it(@"Should return nil",
                                               ^{
                                                   __block id placemarkReturned;

                                                   [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace
                                                                                      apiKey:testApiKey
                                                                                  completion:^(CLPlacemark *placemark,
                                                                                               NSString *addressString,
                                                                                               NSError *error) {

                                                                                      placemarkReturned = placemark;

                                                                                  }];

                                                   [[expectFutureValue(placemarkReturned) shouldEventually] beNil];
                                               });

                                        });

                                    context(
                                        @"One placemark returned by geocoder",
                                        ^{
                                            __block id testPlacemark;

                                            beforeEach(^{

                                                testPlacemark = [CLPlacemark nullMock];
                                                [CLPlacemark stub:@selector(alloc) andReturn:testPlacemark];

                                                [mockGeocoder stub:@selector(geocodeAddressString:completionHandler:)
                                                         withBlock:^id(NSArray *params) {

                                                             CLGeocoderGeocodeAddressCallback completionHandler =
                                                                 params[1];
                                                             completionHandler(@[ testPlacemark ], nil);

                                                             return nil;
                                                         }];

                                            });

                                            it(@"Should return the placemark",
                                               ^{
                                                   __block id placemarkReturned;

                                                   [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace
                                                                                      apiKey:testApiKey
                                                                                  completion:^(CLPlacemark *placemark,
                                                                                               NSString *addressString,
                                                                                               NSError *error) {

                                                                                      placemarkReturned = placemark;

                                                                                  }];

                                                   [[expectFutureValue(placemarkReturned) shouldEventually]
                                                       equal:testPlacemark];
                                               });

                                        });

                                    context(
                                        @"More than one placemark returned by geocoder",
                                        ^{

                                            __block NSArray *testPlacemarks;

                                            beforeEach(^{

                                                id testPlacemark1 = [CLPlacemark nullMock];
                                                id testPlacemark2 = [CLPlacemark nullMock];

                                                testPlacemarks = @[ testPlacemark1, testPlacemark2 ];

                                                [mockGeocoder stub:@selector(geocodeAddressString:completionHandler:)
                                                         withBlock:^id(NSArray *params) {

                                                             CLGeocoderGeocodeAddressCallback completionHandler =
                                                                 params[1];
                                                             completionHandler(testPlacemarks, nil);

                                                             return nil;
                                                         }];

                                            });

                                            it(@"Should return the first placemark",
                                               ^{
                                                   __block id placemarkReturned;
                                                   [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace
                                                                                      apiKey:testApiKey
                                                                                  completion:^(CLPlacemark *placemark,
                                                                                               NSString *addressString,
                                                                                               NSError *error) {

                                                                                      placemarkReturned = placemark;

                                                                                  }];

                                                   [[expectFutureValue(placemarkReturned) shouldEventually]
                                                       equal:testPlacemarks[0]];
                                               });

                                        });
                                });

                        });

                    context(@"Fetching Place Details not successful",
                            ^{

                                context(
                                    @"Server error",
                                    ^{

                                        __block NSError *testError;

                                        beforeEach(^{

                                            testError = [NSError errorWithDomain:@"Test Domain"
                                                                            code:100
                                                                        userInfo:@{
                                                                            @"user" : @"info"
                                                                        }];

                                            [HNKGooglePlacesAutocompleteServer
                                                     stub:@selector(GET:parameters:completion:)
                                                withBlock:^id(NSArray *params) {

                                                    HNKGooglePlacesAutocompleteServerCallback completion = params[2];
                                                    completion(nil, testError);

                                                    return nil;

                                                }];

                                        });

                                        it(@"Should return error",
                                           ^{
                                               __block NSError *errorReturned;
                                               [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace
                                                                                  apiKey:testApiKey
                                                                              completion:^(CLPlacemark *placemark,
                                                                                           NSString *addressString,
                                                                                           NSError *error) {

                                                                                  errorReturned = error;

                                                                              }];

                                               [[expectFutureValue(errorReturned) shouldEventually] equal:testError];
                                           });

                                    });
                            });

                });

        });

});

SPEC_END