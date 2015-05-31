//
//  HNKGooglePlacesAutocompleteQueryConfig.h
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

#import <Foundation/Foundation.h>

#import "HNKGooglePlacesAutocompletePlace.h"

/**
 *  Parameters that can be used to adjust autocomplete
 *  search results
 */
@interface HNKGooglePlacesAutocompleteQueryConfig : NSObject

/**
 *  Country to which search results are restricted.
 *
 *  Note: Must be a two character, ISO 3166-1 Alpha-2
 *  compatible country code
 */
@property (nonatomic, copy) NSString *country;

/**
 *  Place type filter by which results are restricted
 */
@property (nonatomic, assign) HNKGooglePlaceTypeAutocompleteFilter filter;

/**
 *  The language in which search results are returned
 *
 *  The list of supported languages can be found here:
 *  https://developers.google.com/maps/faq#languagesupportNote
 */
@property (nonatomic, copy) NSString *language;

/**
 *  The latitude around which place information is returned
 */
@property (nonatomic, assign) double latitude;

/**
 *  The longitude around which place information is returned
 */
@property (nonatomic, assign) double longitude;

/**
 *  The position, in the input term, of the last
 *  character that the service uses to match predictions
 */
@property (nonatomic, assign) NSInteger offset;

/**
 *  Distance in meters within which place results are biased
 */
@property (nonatomic, assign) NSInteger searchRadius;

#pragma mark - Initialization

#pragma mark Convenience

+ (instancetype)configWithConfig:(HNKGooglePlacesAutocompleteQueryConfig *)config;

#pragma mark - Methods

/**
 *  Translation of properties into parameter dictionary for
 *  requests to Google Places API
 */
- (NSDictionary *)translateToServerRequestParameters;

@end
