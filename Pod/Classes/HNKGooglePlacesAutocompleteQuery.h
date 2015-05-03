//
//  HNKGooglePlacesAutocompleteQuery.h
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

#import "HNKQueryResponse.h"

/**
 *  Status descriptions
 */
extern NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionUnknown;
extern NSString *const
    HNKGooglePlacesAutocompleteQueryStatusDescriptionInvalidRequest;
extern NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionOK;
extern NSString *const
    HNKGooglePlacesAutocompleteQueryStatusDescriptionOverQueryLimit;
extern NSString *const
    HNKGooglePlacesAutocompleteQueryStatusDescriptionRequestDenied;
extern NSString *const
    HNKGooglePlacesAutocompleteQueryStatusDescriptionZeroResults;
extern NSString *const
    HNKGooglePlacesAutocompleteQueryStatusDescriptionSearchQueryNil;

/**
 *  Error domain for HNKGooglePlacesAutocompleteQuery
 */
extern NSString *const HNKGooglePlacesAutocompleteQueryErrorDomain;

/**
 *  Error codes for HNKGooglePlacesAutcompleteQuery requests
 */
typedef NS_ENUM(NSInteger, HNKGooglePlacesAutocompleteQueryErrorCode) {
  /**
   *  Unknown status code returned
   */
  HNKGooglePlacesAutocompleteQueryErrorCodeUnknown =
      HNKQueryResponseStatusUnknown,
  /**
   *  Invalid request; the search query may have been missing
   */
  HNKGooglePlacesAutocompleteQueryErrorCodeInvalidRequest =
      HNKQueryResponseStatusInvalidRequest,
  /**
   *  Query quota has been exceeded for provided API key
   */
  HNKGooglePlacesAutocompleteQueryErrorCodeOverQueryLimit =
      HNKQueryResponseStatusOverQueryLimit,
  /**
   *  Request denied; the API key may be invalid
   */
  HNKGooglePlacesAutocompleteQueryErrorRequestDenied =
      HNKQueryResponseStatusRequestDenied,
  /**
   *  Non-API error occurred while making a request to the server
   */
  HNKGooglePlacesAutcompleteQueryErrorCodeServerRequestFailed = 6,
  /**
   *  Search query was nil
   */
  HNKgooglePlacesAutocompleteQueryErrorCodeSearchQueryNil = 7
};

/**
 *  Query used to fetch objects from the API
 */
@interface HNKGooglePlacesAutocompleteQuery : NSObject

#pragma mark - Initialization

/**
 *  Sets up shared HNKGooglePlacesAutocompleteQuery instance with provided
 *  API key
 */
+ (instancetype)setupSharedQueryWithAPIKey:(NSString *)apiKey;

/**
 * Returns shared HNKGooglePlacesAutocompleteQuery instance
 *
 * Note: Should only be called after sharedSharedQueryWithAPIKey:
 */
+ (instancetype)sharedQuery;

#pragma mark - Requests

/**
 *  Fetches Places given a search query
 *
 *  @param searchQuery String to search for Places with
 *  @param completion  Block to be executed when the fetch finishes
 */
- (void)fetchPlacesForSearchQuery:(NSString *)searchQuery
                       completion:
                           (void (^)(NSArray *places, NSError *))completion;

@end
