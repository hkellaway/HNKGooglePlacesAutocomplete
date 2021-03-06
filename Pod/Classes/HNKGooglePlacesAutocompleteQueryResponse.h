//
//  HNKGooglePlacesAutocompleteQueryResponse.h
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
 *  Status codes for HNKGooglePlacesAutcompleteQueryResponse
 */
typedef NS_ENUM(NSInteger, HNKGooglePlacesAutocompleteQueryResponseStatus) {
    /**
     *  Unknown status
     */
    HNKGooglePlacesAutocompleteQueryResponseStatusUnknown = 0,
    /**
     *  Invalid request; the input parameter may be missing
     */
    HNKGooglePlacesAutocompleteQueryResponseStatusInvalidRequest = 1,
    /**
     *   No errors occurred and at least one result was returned
     */
    HNKGooglePlacesAutocompleteQueryResponseStatusOK = 2,
    /**
     *  Query quota has been exceeded for provided API key
     */
    HNKGooglePlacesAutocompleteQueryResponseStatusOverQueryLimit = 3,
    /**
     *  Request denied; the key parameter may be invalid
     */
    HNKGooglePlacesAutocompleteQueryResponseStatusRequestDenied = 4,
    /**
     *  No errors occurred but no results were returned
     */
    HNKGooglePlacesAutocompleteQueryResponseStatusZeroResults = 5
};

/**
 *  Response returned from an API query
 */
@interface HNKGooglePlacesAutocompleteQueryResponse : HNKGooglePlacesAutocompleteModel

/**
 *  Collection of Places returned from the query
 */
@property (nonatomic, strong, readonly) NSArray *places;

/**
 *  Status of the QueryResponse which may contain debugging information to help
 *  you track down why the query request failed
 */
@property (nonatomic, assign, readonly) HNKGooglePlacesAutocompleteQueryResponseStatus status;

/**
 *  When the status code returned is other than OK, this may hold
 *  additional information about the reasons behind the given status code.
 */
@property (nonatomic, copy, readonly) NSString *errorMessage;

@end
