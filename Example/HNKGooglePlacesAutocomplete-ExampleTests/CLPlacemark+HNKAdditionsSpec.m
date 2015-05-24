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
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesServer.h>

#import "CLPlacemark+HNKAdditions.h"

SPEC_BEGIN(CLPlacemark_HNKAdditionsSpec)

describe(@"CLPlacemark+HNKAdditions", ^{

    describe(
        @"Method: placemarkFromGooglePlace:completion:",
        ^{
            typedef void (^HNKGooglePlacesServerCallback)(id responseObject, NSError *error);
            typedef void (^CLGeocoderGeocodeAddressCallback)(NSArray *placemarks, NSError *error);
            typedef void (^CLPlacemarkResolveToGooglePlaceCallback)(CLPlacemark *, NSString *, NSError *);

            __block NSString *testPlaceId;
            __block HNKGooglePlacesAutocompletePlace *mockPlace;
            __block id mockGeocoder;
            __block NSString *testApiKey;
            __block NSDictionary *testDetailsJSON;

            beforeEach(^{

                testPlaceId = @"ChIJcWGw3Ytzj1QR7Ui7HnTz6Dg";
                mockPlace = [HNKGooglePlacesAutocompletePlace nullMock];
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

            });

            context(@"Place is solely a geocode result",
                    ^{

                        beforeEach(^{

                            [mockPlace stub:@selector(types) andReturn:@[ @(HNKGooglePlaceTypeGeocode) ]];
                            [mockPlace stub:@selector(isPlaceType:)
                                    andReturn:theValue(YES)
                                withArguments:theValue(HNKGooglePlaceTypeGeocode)];

                        });

                        it(@"Should not make server request",
                           ^{

                               [[HNKGooglePlacesServer shouldNot] receive:@selector(GET:parameters:completion:)];

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
                @"Place is not solely a geocode result",
                ^{

                    beforeEach(^{

                        [mockPlace stub:@selector(isPlaceType:)
                                andReturn:theValue(NO)
                            withArguments:theValue(HNKGooglePlaceTypeGeocode)];

                    });

                    it(@"Should make server request",
                       ^{

                           [[HNKGooglePlacesServer should] receive:@selector(GET:parameters:completion:)
                                                     withArguments:@"details/json",
                                                                   @{ @"placeid" : testPlaceId,
                                                                      @"key" : testApiKey },
                                                                   any()];

                           [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace apiKey:testApiKey completion:nil];

                       });

                    context(
                        @"Fetching Place Details successful",
                        ^{

                            beforeEach(^{

                                [HNKGooglePlacesServer stub:@selector(GET:parameters:completion:)
                                                  withBlock:^id(NSArray *params) {

                                                      HNKGooglePlacesServerCallback completion = params[2];
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

                            context(
                                @"Geocoder returns error",
                                ^{

                                    __block NSError *testError;

                                    beforeEach(^{

                                        [mockGeocoder stub:@selector(geocodeAddressString:completionHandler:)
                                                 withBlock:^id(NSArray *params) {

                                                     testError =
                                                         [NSError errorWithDomain:@"kCLErrorDomain"
                                                                             code:-1
                                                                         userInfo:@{
                                                                             @"NSLocalizedDescription" : @"abc",
                                                                             @"NSLocalizedFailureReason" : @"xyz"
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

                                    context(
                                        @"Geocoder returns error again",
                                        ^{
                                            it(@"Should return custom error with orignal error documented",
                                               ^{
                                                   __block NSError *errorReturned;
                                                   NSError *expectedError = [NSError
                                                       errorWithDomain:HNKGooglePlacesAutocompleteCLPlacemarkErrorDomain
                                                                  code:HNKCLPlacemarkErrorCodeCLGeocoderFailure
                                                              userInfo:@{
                                                                  @"NSLocalizedDescription" :
                                                                      HNKCLPlacemarkDescriptionForErrorCode(
                                                                          HNKCLPlacemarkErrorCodeCLGeocoderFailure),
                                                                  @"NSLocalizedFailureReason" :
                                                                      testError.localizedFailureReason,
                                                                  @"NSUnderlyingError" : testError
                                                              }];
                                                   [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace
                                                                                      apiKey:testApiKey
                                                                                  completion:^(CLPlacemark *placemark,
                                                                                               NSString *addressString,
                                                                                               NSError *error) {

                                                                                      errorReturned = error;

                                                                                  }];

                                                   [[expectFutureValue(errorReturned) shouldEventually]
                                                       equal:expectedError];
                                               });

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

                    context(
                        @"Fetching Place Details not successful",
                        ^{

                            context(
                                @"Server error",
                                ^{

                                    __block NSError *testError;

                                    beforeEach(^{

                                        testError = [NSError errorWithDomain:@"Test Domain"
                                                                        code:100
                                                                    userInfo:@{
                                                                        @"NSLocalizedDescription" : @"abc",
                                                                        @"NSLocalizedFailureReason" : @"xyz"
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
                                           __block NSError *errorReturned;
                                           NSError *expectedError = [NSError
                                               errorWithDomain:HNKGooglePlacesAutocompleteCLPlacemarkErrorDomain
                                                          code:HNKCLPlacemarkErrorCodeGoogleFailure
                                                      userInfo:@{
                                                          @"NSLocalizedDescription" :
                                                              HNKCLPlacemarkDescriptionForErrorCode(
                                                                  HNKCLPlacemarkErrorCodeGoogleFailure),
                                                          @"NSLocalizedFailureReason" :
                                                              testError.localizedFailureReason,
                                                          @"NSUnderlyingError" : testError
                                                      }];
                                           [CLPlacemark hnk_placemarkFromGooglePlace:mockPlace
                                                                              apiKey:testApiKey
                                                                          completion:^(CLPlacemark *placemark,
                                                                                       NSString *addressString,
                                                                                       NSError *error) {

                                                                              errorReturned = error;

                                                                          }];

                                           [[expectFutureValue(errorReturned) shouldEventually] equal:expectedError];
                                       });

                                });
                        });

                });

        });

});

SPEC_END
