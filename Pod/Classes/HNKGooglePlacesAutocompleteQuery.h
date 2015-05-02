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
 *  Error domain for HNKGooglePlacesAutocompleteQuery
 */
extern NSString *const HNKGooglePlacesAutocompleteQueryErrorDomain;

typedef NS_ENUM(NSInteger, HNKGooglePlacesAutocompleteQueryErrorCode) {
  HNKGooglePlacesAutcompleteQueryErrorCodeRequestFailed = -1,
  HNKGooglePlacesAutocompleteQueryErrorCodeUnknown =
      HNKQueryResponseStatusUnknown,
  HNKGooglePlacesAutocompleteQueryErrorCodeInvalidRequest =
      HNKQueryResponseStatusInvalidRequest,
  HNKGooglePlacesAutocompleteQueryErrorCodeOverQueryLimit =
      HNKQueryResponseStatusOverQueryLimit,
  HNKGooglePlacesAutocompleteQueryErrorRequestDenied =
      HNKQueryResponseStatusRequestDenied
};

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

- (void)fetchPlacesForSearchQuery:(NSString *)searchQuery
                       completion:
                           (void (^)(NSArray *places, NSError *))completion;

@end
