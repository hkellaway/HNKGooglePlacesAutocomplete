//
//  CLPlacemark+HNKAdditions.m
//  HNKGooglePlacesAutocomplete
//
// Copyright (c) 2015 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "HNKGooglePlacesAutocompletePlace.h"
#import "HNKGooglePlacesServer.h"

#import "CLPlacemark+HNKAdditions.h"

#pragma mark Error constants

NSString *const HNKGooglePlacesAutocompleteCLPlacemarkErrorDomain =
    @"com.hnkgoogleplacesautocomplete.category.clplacemark.error";

static NSString *const HNKCLPlacemarkErrorCodeDescriptionUnknown = @"Unknown error occurred";
static NSString *const HNKCLPlacemarkErrorCodeDescriptionGeocoderFailure = @"Geocoder error";
static NSString *const HNKCLPlacemarkErrorCodeDescriptionGoogleFailure = @"API error";

#pragma mark Request constants

static NSString *const kHNKGooglePlacesServerRequestPathDetails = @"details/json";

@implementation CLPlacemark (HNKAdditions)

+ (void)hnk_placemarkFromGooglePlace:(HNKGooglePlacesAutocompletePlace *)place
                              apiKey:(NSString *)apiKey
                          completion:(void (^)(CLPlacemark *, NSString *, NSError *))completion
{
    [self addressForPlace:place
                   apiKey:apiKey
               completion:^(NSString *addressString, NSError *error) {

                   if (error) {

                       NSError *customError =
                           [self customErrorWithCode:HNKCLPlacemarkErrorCodeGoogleFailure underlyingError:error];
                       completion(nil, nil, customError);

                   } else {

                       [self completeForPlace:place withAddress:addressString completion:completion];
                   }
               }];
}

#pragma mark - Helpers

+ (void)addressForPlace:(HNKGooglePlacesAutocompletePlace *)place
                 apiKey:(NSString *)apiKey
             completion:(void (^)(NSString *addressString, NSError *error))completion
{

    if ([self isSolelyGeocodePlace:place]) {
        completion(place.name, nil);
    } else {

        [HNKGooglePlacesServer GET:kHNKGooglePlacesServerRequestPathDetails
                        parameters:@{
                            @"placeid" : place.placeId,
                            @"key" : apiKey
                        }
                        completion:^(NSDictionary *JSON, NSError *error) {

                            if (error) {
                                completion(nil, error);
                            } else {

                                NSString *address = JSON[@"result"][@"formatted_address"];
                                completion(address, nil);
                            }
                        }];
    }
}

+ (BOOL)isSolelyGeocodePlace:(HNKGooglePlacesAutocompletePlace *)place
{
    return (([place.types count] == 1) && [place isPlaceType:HNKGooglePlaceTypeGeocode]);
}

+ (void)completeForPlace:(HNKGooglePlacesAutocompletePlace *)place
             withAddress:(NSString *)addressString
              completion:(void (^)(CLPlacemark *placemark, NSString *addressString, NSError *error))completion
{

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];

    if (addressString != nil) {
        [self geocodeAddress:addressString forPlace:place withGeocoder:geocoder completion:completion];
    } else {
        [self geocodePlaceName:place.name withGeocoder:geocoder completion:completion];
    }
}

+ (void)geocodeAddress:(NSString *)address
              forPlace:(HNKGooglePlacesAutocompletePlace *)place
          withGeocoder:(CLGeocoder *)geocoder
            completion:(void (^)(CLPlacemark *placemark, NSString *addressString, NSError *error))completion
{
    [geocoder geocodeAddressString:address
                 completionHandler:^(NSArray *placemarks, NSError *error) {

                     if (error) {
                         [self geocodePlaceName:place.name withGeocoder:geocoder completion:completion];
                     } else {
                         [self completeWithPlacemarks:placemarks address:address completion:completion];
                     }

                 }];
}

+ (void)geocodePlaceName:(NSString *)placeName
            withGeocoder:(CLGeocoder *)geocoder
              completion:(void (^)(CLPlacemark *placemark, NSString *addressString, NSError *error))completion
{
    [geocoder geocodeAddressString:placeName
                 completionHandler:^(NSArray *placemarks, NSError *error) {

                     if (error) {

                         NSError *customError =
                             [self customErrorWithCode:HNKCLPlacemarkErrorCodeCLGeocoderFailure underlyingError:error];
                         completion(nil, nil, customError);

                     } else {
                         [self completeWithPlacemarks:placemarks address:placeName completion:completion];
                     }

                 }];
}

+ (void)completeWithPlacemarks:(NSArray *)placemarks
                       address:(NSString *)address
                    completion:(void (^)(CLPlacemark *placemark, NSString *addressString, NSError *error))completion
{
    CLPlacemark *singlePlacemark = [placemarks count] >= 1 ? placemarks[0] : nil;
    completion(singlePlacemark, address, nil);
}

+ (NSError *)customErrorWithCode:(HNKCLPlacemarkErrorCode)errorCode underlyingError:(NSError *)error
{
    NSString *errorLocalizedDescription = HNKCLPlacemarkDescriptionForErrorCode(errorCode);
    NSString *errorLocalizedFailureReason =
        error.localizedFailureReason ? error.localizedFailureReason : errorLocalizedDescription;

    NSError *customError = [NSError errorWithDomain:HNKGooglePlacesAutocompleteCLPlacemarkErrorDomain
                                               code:errorCode
                                           userInfo:@{
                                               @"NSLocalizedDescription" : errorLocalizedDescription,
                                               @"NSLocalizedFailureReason" : errorLocalizedFailureReason,
                                               @"NSUnderlyingError" : error
                                           }];

    return customError;
}

NSString *HNKCLPlacemarkDescriptionForErrorCode(HNKCLPlacemarkErrorCode errorCode)
{
    switch (errorCode) {
    case HNKCLPlacemarkErrorCodeUnknown: {
        return HNKCLPlacemarkErrorCodeDescriptionUnknown;
        break;
    }
    case HNKCLPlacemarkErrorCodeCLGeocoderFailure: {
        return HNKCLPlacemarkErrorCodeDescriptionGeocoderFailure;
        break;
    }
    case HNKCLPlacemarkErrorCodeGoogleFailure: {
        return HNKCLPlacemarkErrorCodeDescriptionGoogleFailure;
        break;
    }
    default: {
        return HNKCLPlacemarkErrorCodeDescriptionUnknown;
        break;
    }
    }
}

@end
