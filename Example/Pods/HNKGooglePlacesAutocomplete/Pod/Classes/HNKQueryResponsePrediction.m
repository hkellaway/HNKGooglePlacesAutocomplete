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

- (BOOL)isPlaceType:(HNKGooglePlacesAutocompletePlaceType)placeType {
  NSArray *allTypes = self.types;

  for (int i = 0; i < [allTypes count]; i++) {
    NSNumber *number = allTypes[i];
    if (number.integerValue == placeType) {
      return YES;
    }
  }

  return NO;
}

#pragma mark - Protocol conformance

#pragma mark <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"name" : @"description",
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
    @"administrative_area_level_1" :
        @(HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel1),
    @"administrative_area_level_2" :
        @(HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel2),
    @"administrative_area_level_3" :
        @(HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel3),
    @"administrative_area_level_4" :
        @(HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel4),
    @"administrative_area_level_5" :
        @(HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel5),
    @"colloquial_area" : @(HNKGooglePlacesAutocompletePlaceTypeColloquialArea),
    @"country" : @(HNKGooglePlacesAutocompletePlaceTypeCountry),
    @"establishment" : @(HNKGooglePlacesAutocompletePlaceTypeEstablishment),
    @"floor" : @(HNKGooglePlacesAutocompletePlaceTypeFloor),
    @"geocode" : @(HNKGooglePlacesAutocompletePlaceTypeGeocode),
    @"intersection" : @(HNKGooglePlacesAutocompletePlaceTypeIntersection),
    @"locality" : @(HNKGooglePlacesAutocompletePlaceTypeLocality),
    @"natural_feature" : @(HNKGooglePlacesAutocompletePlaceTypeNaturalFeature),
    @"neighborhood" : @(HNKGooglePlacesAutocompletePlaceTypeNeighborhood),
    @"political" : @(HNKGooglePlacesAutocompletePlaceTypePolitical),
    @"point_of_interest" :
        @(HNKGooglePlacesAutocompletePlaceTypePointOfInterest),
    @"post_box" : @(HNKGooglePlacesAutocompletePlaceTypePostBox),
    @"postal_code" : @(HNKGooglePlacesAutocompletePlaceTypePostalCode),
    @"postal_code_prefix" :
        @(HNKGooglePlacesAutocompletePlaceTypePostalCodePrefix),
    @"postal_code_suffix" :
        @(HNKGooglePlacesAutocompletePlaceTypePostalCodeSuffix),
    @"postal_town" : @(HNKGooglePlacesAutocompletePlaceTypePostalTown),
    @"premise" : @(HNKGooglePlacesAutocompletePlaceTypePremise),
    @"room" : @(HNKGooglePlacesAutocompletePlaceTypeRoom),
    @"route" : @(HNKGooglePlacesAutocompletePlaceTypeRoute),
    @"street_address" : @(HNKGooglePlacesAutocompletePlaceTypeStreetAddress),
    @"street_number" : @(HNKGooglePlacesAutocompletePlaceTypeStreetNumber),
    @"sublocality" : @(HNKGooglePlacesAutocompletePlaceTypeSublocality),
    @"sublocality_level_1" :
        @(HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel1),
    @"sublocality_level_2" :
        @(HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel2),
    @"sublocality_level_3" :
        @(HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel3),
    @"sublocality_level_4" :
        @(HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel4),
    @"sublocality_level_5" :
        @(HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel5),
    @"subpremise" : @(HNKGooglePlacesAutocompletePlaceTypeSubpremise),
    @"transit_station" : @(HNKGooglePlacesAutocompletePlaceTypeTransitStation),
    @"unknown" : @(HNKGooglePlacesAutocompletePlaceTypeUnknown)
  };

  return [MTLValueTransformer transformerWithBlock:^(NSArray *types) {
    NSMutableArray *typesToReturn =
        [NSMutableArray arrayWithCapacity:[types count]];
    for (NSString *type in types) {
      if ([typesDictionary objectForKey:type]) {
        [typesToReturn addObject:typesDictionary[type]];
      } else {
        [typesToReturn addObject:typesDictionary[@"unknown"]];
      }
    }
    return [typesToReturn copy];
  }];
}

@end
