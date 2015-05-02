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

typedef NS_ENUM(NSInteger, HNKGooglePlacesAutocompletePlaceType) {
  HNKGooglePlacesAutocompletePlaceTypeUnknown = 0,
  HNKGooglePlacesAutocompletePlaceTypeAddress,
  HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel1,
  HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel2,
  HNKGooglePlacesAutocompletePlaceTypeAdministrativeAreaLevel3,
  HNKGooglePlacesAutocompletePlaceTypeCities,
  HNKGooglePlacesAutocompletePlaceTypeCountry,
  HNKGooglePlacesAutocompletePlaceTypeEstablishment,
  HNKGooglePlacesAutocompletePlaceTypeGeocode,
  HNKGooglePlacesAutocompletePlaceTypeLocality,
  HNKGooglePlacesAutocompletePlaceTypePolitical,
  HNKGooglePlacesAutocompletePlaceTypePostalCode,
  HNKGooglePlacesAutocompletePlaceTypeRegions,
  HNKGooglePlacesAutocompletePlaceTypeSublocality
};

@interface HNKQueryResponsePrediction : HNKGooglePlacesAutocompleteModel

/**
 *  Human-readable name for the returned result
 *
 *  Note: For establishment results, this is usually the business name
 */
@property(nonatomic, strong, readonly) NSString *predictionDescription;

/**
 *  Collection of QueryResponsePredictionMatchedSubstrings that the location
 *  of the entered term in the predictionresult text, so that the term can be
 *  highlighted if desired
 */
@property(nonatomic, strong, readonly) NSArray *matchedSubstrings;

/**
 *  A textual identifier that uniquely identifies a place
 */
@property(nonatomic, strong, readonly) NSString *placeId;

/**
 *  A collection of QueryResponsePredictionTerms identifying each section
 *  of the returned description
 */
@property(nonatomic, strong, readonly) NSArray *terms;

/**
 *  A collection of PlaceTypes that apply to this place
 */
@property(nonatomic, strong, readonly) NSArray *types;

@end
