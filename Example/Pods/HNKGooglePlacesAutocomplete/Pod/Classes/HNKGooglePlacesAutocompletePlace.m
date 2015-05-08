//
//  HNKGooglePlacesAutocompletePlace.m
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
#import "HNKGooglePlacesAutocompletePlaceSubstring.h"
#import "HNKGooglePlacesAutocompletePlaceTerm.h"

#import "NSValueTransformer+MTLPredefinedTransformerAdditions.h"

@implementation HNKGooglePlacesAutocompletePlace

- (BOOL)isPlaceType:(HNKGooglePlaceType)placeType {
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
    @"substrings" : @"matched_substrings",
    @"placeId" : @"place_id",
    @"terms" : @"terms",
    @"types" : @"types"
  };
}

+ (NSValueTransformer *)substringsJSONTransformer {
  return [NSValueTransformer
      mtl_JSONArrayTransformerWithModelClass:
          [HNKGooglePlacesAutocompletePlaceSubstring class]];
}

+ (NSValueTransformer *)termsJSONTransformer {
  return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:
                                 [HNKGooglePlacesAutocompletePlaceTerm class]];
}

+ (NSValueTransformer *)typesJSONTransformer {
  NSDictionary *typesDictionary = @{
    @"administrative_area_level_1" :
        @(HNKGooglePlaceTypeAdministrativeAreaLevel1),
    @"administrative_area_level_2" :
        @(HNKGooglePlaceTypeAdministrativeAreaLevel2),
    @"administrative_area_level_3" :
        @(HNKGooglePlaceTypeAdministrativeAreaLevel3),
    @"administrative_area_level_4" :
        @(HNKGooglePlaceTypeAdministrativeAreaLevel4),
    @"administrative_area_level_5" :
        @(HNKGooglePlaceTypeAdministrativeAreaLevel5),
    @"colloquial_area" : @(HNKGooglePlaceTypeColloquialArea),
    @"country" : @(HNKGooglePlaceTypeCountry),
    @"establishment" : @(HNKGooglePlaceTypeEstablishment),
    @"floor" : @(HNKGooglePlaceTypeFloor),
    @"geocode" : @(HNKGooglePlaceTypeGeocode),
    @"intersection" : @(HNKGooglePlaceTypeIntersection),
    @"locality" : @(HNKGooglePlaceTypeLocality),
    @"natural_feature" : @(HNKGooglePlaceTypeNaturalFeature),
    @"neighborhood" : @(HNKGooglePlaceTypeNeighborhood),
    @"political" : @(HNKGooglePlaceTypePolitical),
    @"point_of_interest" : @(HNKGooglePlaceTypePointOfInterest),
    @"post_box" : @(HNKGooglePlaceTypePostBox),
    @"postal_code" : @(HNKGooglePlaceTypePostalCode),
    @"postal_code_prefix" : @(HNKGooglePlaceTypePostalCodePrefix),
    @"postal_code_suffix" : @(HNKGooglePlaceTypePostalCodeSuffix),
    @"postal_town" : @(HNKGooglePlaceTypePostalTown),
    @"premise" : @(HNKGooglePlaceTypePremise),
    @"room" : @(HNKGooglePlaceTypeRoom),
    @"route" : @(HNKGooglePlaceTypeRoute),
    @"street_address" : @(HNKGooglePlaceTypeStreetAddress),
    @"street_number" : @(HNKGooglePlaceTypeStreetNumber),
    @"sublocality" : @(HNKGooglePlaceTypeSublocality),
    @"sublocality_level_1" : @(HNKGooglePlaceTypeSublocalityLevel1),
    @"sublocality_level_2" : @(HNKGooglePlaceTypeSublocalityLevel2),
    @"sublocality_level_3" : @(HNKGooglePlaceTypeSublocalityLevel3),
    @"sublocality_level_4" : @(HNKGooglePlaceTypeSublocalityLevel4),
    @"sublocality_level_5" : @(HNKGooglePlaceTypeSublocalityLevel5),
    @"subpremise" : @(HNKGooglePlaceTypeSubpremise),
    @"transit_station" : @(HNKGooglePlaceTypeTransitStation),
    @"unknown" : @(HNKGooglePlaceTypeUnknown)
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
