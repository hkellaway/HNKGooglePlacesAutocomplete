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

    describe(
        @"Method: hnk_placemarkFromGooglePlace:completion:",
        ^{

            __block HNKQueryResponsePrediction *testPlace;

            beforeEach(^{

                testPlace = [[HNKQueryResponsePrediction alloc] init];
                [testPlace stub:@selector(placeId) andReturn:@"abc"];

            });

            context(@"Place is a geocode result",
                    ^{

                        beforeEach(^{

                            [CLPlacemark stub:@selector(isGeocodeResult:) andReturn:theValue(YES)];

                        });

                        it(@"Should not make a server request",
                           ^{

                               [[HNKGooglePlacesAutocompleteServer shouldNot]
                                   receive:@selector(GET:parameters:completion:)];

                               [CLPlacemark hnk_placemarkFromGooglePlace:testPlace completion:nil];

                           });

                    });

            context(
                @"Place is not a geocode result",
                ^{

                    beforeEach(^{

                        [CLPlacemark stub:@selector(isGeocodeResult:) andReturn:theValue(NO)];

                    });

                    it(@"Should make a server request",
                       ^{

                           [[HNKGooglePlacesAutocompleteServer should] receive:@selector(GET:parameters:completion:)];

                           [CLPlacemark hnk_placemarkFromGooglePlace:testPlace completion:nil];

                       });

                });

        });

});

SPEC_END