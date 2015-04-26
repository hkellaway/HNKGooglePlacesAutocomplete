//
//  HNKQueryResponsePrediction.h
//  Pods
//
//  Created by Harlan Kellaway on 4/26/15.
//
//

#import "HNKGooglePlacesAutocompleteModel.h"

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
