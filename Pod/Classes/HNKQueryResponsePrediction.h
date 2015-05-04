//
//  HNKQueryResponsePrediction.h
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

#import "HNKGooglePlacesAutocompleteModel.h"

/**
 *  Place types
 */
typedef NS_ENUM(NSInteger, HNKGooglePlacesAutocompletePlaceType) {
  /**
   *  Places of type unknown
   */
  HNKGooglePlacesAutocompletePlaceTypeUnknown = 0,
  /**
   *  Places with a precise address
   */
  HNKGooglePlacesAutocompletePlaceTypeAddress,
  /**
   *  Places of type Administrative Area Level 1
   */
  HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel1,
  /**
   *  Places of type Administrative Area Level 2
   */
  HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel2,
  /**
   *  Places of type Administrative Area Level 3
   */
  HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel3,
  /**
   *  Places of type Administrative Area Level 4
   */
  HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel4,
  /**
   *  Places of type Administrative Area Level 5
   */
  HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel5,
  /**
   *  Places of type locality or Administrative Area 3
   */
  HNKGooglePlacesAutocompletePlaceTypeCities,
  /**
   *  Places of type colloquial area
   */
  HNKGooglePlacesAutocompletePlaceTypeColloquialArea,
  /**
   *  Places of type country
   */
  HNKGooglePlacesAutocompletePlaceTypeCountry,
  /**
   *  Places from only business results
   */
  HNKGooglePlacesAutocompletePlaceTypeEstablishment,
  /**
   *  Places of type floor
   */
  HNKGooglePlacesAutocompletePlaceTypeFloor,
  /**
   *  Places from only geocoding results, not business results
   */
  HNKGooglePlacesAutocompletePlaceTypeGeocode,
  /**
   *  Places of type intersection
   */
  HNKGooglePlacesAutocompletePlaceTypeIntersection,
  /**
   *  Places of type locality
   */
  HNKGooglePlacesAutocompletePlaceTypeLocality,
  /**
   *  Places of type natural feature
   */
  HNKGooglePlacesAutocompletePlaceTypeNaturalFeature,
  /**
   *  Places of type neighborhood
   */
  HNKGooglePlacesAutocompletePlaceTypeNeighborhood,
  /**
   *  Places of type political
   */
  HNKGooglePlacesAutocompletePlaceTypePolitical,
  /**
   *  Places of type point of interest
   */
  HNKGooglePlacesAutocompletePlaceTypePointOfInterest,
  /**
   *  Places of type post box
   */
  HNKGooglePlacesAutocompletePlaceTypePostBox,
  /**
   *  Places of type postal code
   */
  HNKGooglePlacesAutocompletePlaceTypePostalCode,
  /**
   *  Places of type postal code prefix
   */
  HNKGooglePlacesAutocompletePlaceTypePostalCodePrefix,
  /**
   *  Places of type postal code suffix
   */
  HNKGooglePlacesAutocompletePlaceTypePostalCodeSuffix,
  /**
   *  Places of type postal town
   */
  HNKGooglePlacesAutocompletePlaceTypePostalTown,
  /**
   *  Places of type premise
   */
  HNKGooglePlacesAutocompletePlaceTypePremise,
  /**
   *  Places of type room
   */
  HNKGooglePlacesAutocompletePlaceTypeRoom,
  /**
   *  Places of type locality, sub-locality, postal code, country,
   *  Administrative Area Level 1 or Administrative Area Level 2
   */
  HNKGooglePlacesAutocompletePlaceTypeRegions,
  /**
   *  Places of type route
   */
  HNKGooglePlacesAutocompletePlaceTypeRoute,
  /**
   *  Places of type sub-locality
   */
  HNKGooglePlacesAutocompletePlaceTypeSublocality,
  /**
   *  Places of type sub-locality level 1
   */
  HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel1,
  /**
   *  Places of type sub-locality level 2
   */
  HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel2,
  /**
   *  Places of type sub-locality level 3
   */
  HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel3,
  /**
   *  Places of type sub-locality level 4
   */
  HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel4,
  /**
   *  Places of type sub-locality level 5
   */
  HNKGooglePlacesAutocompletePlaceTypeSublocalityLevel5,
  /**
   *  Places of type subpremise
   */
  HNKGooglePlacesAutocompletePlaceTypeSubpremise,
  /**
   *  Places of type transit station
   */
  HNKGooglePlacesAutocompletePlaceTypeTransitStation
};

/**
 *  Place prediction returned from search query
 */
@interface HNKQueryResponsePrediction : HNKGooglePlacesAutocompleteModel

/**
 *  Human-readable name for the returned result
 *
 *  Note: For establishment type results, this is usually the business name
 */
@property(nonatomic, strong, readonly) NSString *predictionDescription;

/**
 *  Collection of Substrings describe the location of the entered term in the
 *  prediction result text, so that the term can be highlighted if desired
 */
@property(nonatomic, strong, readonly) NSArray *matchedSubstrings;

/**
 *  A textual identifier that uniquely identifies a place
 */
@property(nonatomic, strong, readonly) NSString *placeId;

/**
 *  A collection of Terms identifying each section of the returned description
 */
@property(nonatomic, strong, readonly) NSArray *terms;

/**
 *  A collection of NSNumbers whose integerValues corresponse to
 *  HNKGooglePlacesAutocompletePlaceTypes
 */
@property(nonatomic, strong, readonly) NSArray *types;

@end
