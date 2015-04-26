//
//  HNKQueryResponsePredictionTerm.h
//  Pods
//
//  Created by Harlan Kellaway on 4/26/15.
//
//

#import "HNKGooglePlacesAutocompleteModel.h"

@interface HNKQueryResponsePredictionTerm : HNKGooglePlacesAutocompleteModel

@property (nonatomic, assign, readonly) NSInteger offset;
@property (nonatomic, strong, readonly) NSString *value;

@end
