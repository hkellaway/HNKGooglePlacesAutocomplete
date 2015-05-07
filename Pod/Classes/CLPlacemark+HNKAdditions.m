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
#import "HNKGooglePlacesServer.h"

#import "CLPlacemark+HNKAdditions.h"

static NSString *const kHNKGooglePlacesServerRequestPathDetails =
    @"details/json";

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

               } else {

                 [self completeForPlace:(HNKQueryResponsePrediction *)place
                            withAddress:addressString
                             completion:completion];
               }
             }];
}

#pragma mark - Helpers

+ (void)addressForPlace:(HNKQueryResponsePrediction *)place
                 apiKey:(NSString *)apiKey
             completion:
                 (void (^)(NSString *addressString, NSError *error))completion {
  if ([place isPlaceType:HNKGooglePlacesAutocompletePlaceTypeGeocode]) {
    completion(place.name, nil);
    return;
  }

  [HNKGooglePlacesServer GET:kHNKGooglePlacesServerRequestPathDetails
                  parameters:@{
                    @"placeid" : place.placeId,
                    @"key" : apiKey
                  }
                  completion:^(NSDictionary *JSON, NSError *error) {

        if (error) {
          completion(nil, error);
        } else {

          NSDictionary *resultJSON = JSON[@"result"];

          if (resultJSON != nil) {
            NSString *address = resultJSON[@"formatted_address"];

            if (address != nil) {
              completion(address, nil);
            } else {
              completion(nil, nil);
            }
          }
        }
                  }];
}

+ (void)completeForPlace:(HNKQueryResponsePrediction *)place
             withAddress:(NSString *)addressString
              completion:(void (^)(CLPlacemark *placemark,
                                   NSString *addressString,
                                   NSError *error))completion {

  CLGeocoder *geocoder = [[CLGeocoder alloc] init];

  if (addressString != nil) {
    [self geocodeAddress:addressString
                forPlace:place
            withGeocoder:geocoder
              completion:completion];
  } else {
    [self geocodePlaceName:place.name
              withGeocoder:geocoder
                completion:completion];
  }
}

+ (void)geocodeAddress:(NSString *)address
              forPlace:(HNKQueryResponsePrediction *)place
          withGeocoder:(CLGeocoder *)geocoder
            completion:(void (^)(CLPlacemark *placemark,
                                 NSString *addressString,
                                 NSError *error))completion {
  [geocoder geocodeAddressString:address
               completionHandler:^(NSArray *placemarks, NSError *error) {

                 if (error) {
                   [self geocodePlaceName:place.name
                             withGeocoder:geocoder
                               completion:completion];
                 } else {
                   [self completeWithPlacemarks:placemarks
                                        address:address
                                     completion:completion];
                 }

               }];
}

+ (void)geocodePlaceName:(NSString *)placeName
            withGeocoder:(CLGeocoder *)geocoder
              completion:(void (^)(CLPlacemark *placemark,
                                   NSString *addressString,
                                   NSError *error))completion {
  [geocoder geocodeAddressString:placeName
               completionHandler:^(NSArray *placemarks, NSError *error) {

                 if (error) {
                   completion(nil, nil, error);
                 } else {
                   [self completeWithPlacemarks:placemarks
                                        address:placeName
                                     completion:completion];
                 }

               }];
}

+ (void)completeWithPlacemarks:(NSArray *)placemarks
                       address:(NSString *)address
                    completion:(void (^)(CLPlacemark *placemark,
                                         NSString *addressString,
                                         NSError *error))completion {
  CLPlacemark *singlePlacemark = [placemarks count] >= 1 ? placemarks[0] : nil;
  completion(singlePlacemark, address, nil);
}

@end
