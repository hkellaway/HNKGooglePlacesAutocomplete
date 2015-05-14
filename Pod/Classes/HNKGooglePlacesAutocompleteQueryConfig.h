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

@property(nonatomic, copy, readonly) NSString *country;
@property(nonatomic, assign, readonly)
    HNKGooglePlaceTypeAutocompleteFilter filter;
@property(nonatomic, copy, readonly) NSString *language;
@property(nonatomic, assign, readonly) double latitude;
@property(nonatomic, assign, readonly) double longitude;
@property(nonatomic, assign, readonly) NSInteger offset;
@property(nonatomic, assign, readonly) NSInteger searchRadius;

#pragma mark - Initialization

/**
 *  Returns HNKGooglePlacesAutocompleteQueryConfig instance with provided
 *  configuration properties
 *
 *  Note: This is the designated initializer
 *
 *  @param country      Country to which search results are restricted.
 *                      Must be a two character, ISO 3166-1 Alpha-2
 *                      compatible country code
 *  @param filter       Place type filter by which results are restricted
 *  @param language     The language in which search results are returned.
 *                      The list of supported languages can be found here:
 *                      https://developers.google.com/maps/faq#languagesupportNote
 *  @param latitude     The latitude around which place information is returned
 *  @param longitude    The longitude around which place information is returned
 *  @param offset       The position, in the input term, of the last
 *                      character that the service uses to match predictions
 *  @param searchRadius Distance in meters within which place results are biased
 *
 *  Note: If latitude or longitude are set to NSNotFound
 *  a default location will not be used
 */
- (instancetype)initWithCountry:(NSString *)country
                         filter:(HNKGooglePlaceTypeAutocompleteFilter)filter
                       language:(NSString *)language
                       latitude:(double)latitude
                      longitude:(double)longitude
                         offset:(NSInteger)offset
                   searchRadius:(NSInteger)searchRadius;

#pragma mark - Instance methods

/**
 *  Translation of properties into parameter dictionary for
 *  requests to Google Places API
 */
- (NSDictionary *)translateToServerRequestParameters;

@end
