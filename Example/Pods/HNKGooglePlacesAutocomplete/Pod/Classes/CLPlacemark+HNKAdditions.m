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

#import "HNKQueryResponsePrediction.h"
#import "HNKGooglePlacesAutocompleteServer.h"

#import "CLPlacemark+HNKAdditions.h"

static NSString *const kHNKGooglePlacesDetailsServerRequestPath =
    @"place/details/json";

@implementation CLPlacemark (HNKAdditions)

+ (void)hnk_placemarkFromGooglePlace:(HNKQueryResponsePrediction *)place
                              apiKey:(NSString *)apiKey
                          completion:(void (^)(CLPlacemark *, NSString *,
                                               NSError *))completion {
  [self addressForPlace:place
                 apiKey:apiKey
             completion:^(NSString *addressString, NSError *error) {

               if (error) {
                 completion(nil, nil, error);
                 return;
               }

               CLGeocoder *geocoder = [[CLGeocoder alloc] init];

               [geocoder
                   geocodeAddressString:addressString
                      completionHandler:^(NSArray *placemarks, NSError *error) {
                        if (error) {
                          completion(nil, nil, error);
                        } else {
                          CLPlacemark *placemark =
                              [placemarks count] >= 1 ? placemarks[0] : nil;
                          completion(placemark, addressString, nil);
                        }
                      }];
             }];
}

#pragma mark - Helpers

+ (void)addressForPlace:(HNKQueryResponsePrediction *)place
                 apiKey:(NSString *)apiKey
             completion:
                 (void (^)(NSString *addressString, NSError *error))completion {
  if ([self isGeocodeResult:place]) {
    completion(place.name, nil);
    return;
  }

  [HNKGooglePlacesAutocompleteServer
             GET:kHNKGooglePlacesDetailsServerRequestPath
      parameters:@{
        @"placeid" : place.placeId,
        @"key" : apiKey
      }
      completion:^(NSDictionary *JSON, NSError *error) {

        if (error) {
          completion(nil, error);
          return;
        }

        completion(JSON[@"result"][@"formatted_address"], nil);

      }];
}

+ (BOOL)isGeocodeResult:(HNKQueryResponsePrediction *)place {
  NSArray *allTypes = place.types;

  for (int i = 0; i < [allTypes count]; i++) {
    NSNumber *number = allTypes[i];
    if (number.integerValue == HNKGooglePlacesAutocompletePlaceTypeGeocode) {
      return YES;
    }
  }

  return NO;
}

@end
