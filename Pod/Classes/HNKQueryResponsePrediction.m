//
//  HNKQueryResponsePrediction.m
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
#import "HNKQueryResponsePredictionMatchedSubstring.h"
#import "HNKQueryResponsePredictionTerm.h"

#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation HNKQueryResponsePrediction

#pragma mark - Protocol conformance

#pragma mark <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"predictionDescription" : @"description",
    @"matchedSubstrings" : @"matched_substrings",
    @"placeId" : @"place_id",
    @"terms" : @"terms",
    @"types" : @"types"
  };
}

+ (NSValueTransformer *)matchedSubstringsJSONTransformer {
  return [NSValueTransformer
      mtl_JSONArrayTransformerWithModelClass:
          [HNKQueryResponsePredictionMatchedSubstring class]];
}

+ (NSValueTransformer *)termsJSONTransformer {
  return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:
                                 [HNKQueryResponsePredictionTerm class]];
}

+ (NSValueTransformer *)typesJSONTransformer {
  NSDictionary *typesDictionary = @{
    @"address" : @(HNKGooglePlacesAutocompletePlaceTypeAddress),
    @"administrative_area_level_1" :
        @(HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel1),
    @"administrative_area_level_2" :
        @(HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel2),
    @"administrative_area_level_3" :
        @(HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel3),
    @"country" : @(HNKGooglePlacesAutocompletePlaceTypeCountry),
    @"establishment" : @(HNKGooglePlacesAutocompletePlaceTypeEstablishment),
    @"geocode" : @(HNKGooglePlacesAutocompletePlaceTypeGeocode),
    @"locality" : @(HNKGooglePlacesAutocompletePlaceTypeLocality),
    @"political" : @(HNKGooglePlacesAutocompletePlaceTypePolitical),
    @"postal_code" : @(HNKGooglePlacesAutocompletePlaceTypePostalCode),
    @"sublocality" : @(HNKGooglePlacesAutocompletePlaceTypeSublocality)
  };

  return [MTLValueTransformer transformerWithBlock:^(NSArray *types) {
    NSMutableArray *typesToReturn =
        [NSMutableArray arrayWithCapacity:[types count]];
    for (NSString *type in types) {
      [typesToReturn addObject:typesDictionary[type]];
    }
    return [typesToReturn copy];
  }];
}

@end
