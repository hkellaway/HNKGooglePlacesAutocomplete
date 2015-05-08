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

#import "HNKGooglePlacesAutocompleteQueryResponse.h"

typedef void (^HNKGooglePlacesAutocompleteQueryCallback)(NSArray *places,
                                                         NSError *error);

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
      HNKGooglePlacesAutocompleteQueryResponseStatusUnknown,
  /**
   *  Invalid request; the search query may have been missing
   */
  HNKGooglePlacesAutocompleteQueryErrorCodeInvalidRequest =
      HNKGooglePlacesAutocompleteQueryResponseStatusInvalidRequest,
  /**
   *  Query quota has been exceeded for provided API key
   */
  HNKGooglePlacesAutocompleteQueryErrorCodeOverQueryLimit =
      HNKGooglePlacesAutocompleteQueryResponseStatusOverQueryLimit,
  /**
   *  Request denied; the API key may be invalid
   */
  HNKGooglePlacesAutocompleteQueryErrorCodeRequestDenied =
      HNKGooglePlacesAutocompleteQueryResponseStatusRequestDenied,
  /**
   *  Non-API error occurred while making a request to the server
   */
  HNKGooglePlacesAutcompleteQueryErrorCodeServerRequestFailed = 6,
  /**
   *  Search query was nil
   */
  HNKGooglePlacesAutocompleteQueryErrorCodeSearchQueryNil = 7
};

/**
 *  Short description of error for provided error code
 */
extern NSString *HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(
    HNKGooglePlacesAutocompleteQueryErrorCode errorCode);

/**
 *  Query used to fetch objects from the API
 */
@interface HNKGooglePlacesAutocompleteQuery : NSObject

/**
 *  API key used for all requests
 */
@property(nonatomic, copy, readonly) NSString *apiKey;

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
                           (HNKGooglePlacesAutocompleteQueryCallback)completion;

@end
