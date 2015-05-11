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

typedef struct HNKGooglePlacesAutocompleteLocation
{
    double latitude;
    double longitude;
} HNKGooglePlacesAutocompleteLocation;

@interface HNKGooglePlacesAutocompleteQueryConfig : NSObject

/**
 *  Country to which search results are restricted
 *
 *  Note: The country must be a two character, ISO
 *  3166-1 Alpha-2 compatible country code
 */
@property (nonatomic, copy, readonly) NSString *country;

/**
 *   Place type filter which search results are restricted by
 */
@property (nonatomic, assign, readonly) HNKGooglePlaceTypeAutocompleteFilter filter;

/**
 *  The language in which search results are returned
 *
 *  Note: List of supported domain languages can be found here:
 *  https://developers.google.com/maps/faq#languagesupportNote
 */
@property (nonatomic, copy, readonly) NSString *language;

/**
 *  The point around which place information is returned
 *
 *  @warning Both latitude and longitude should be set
 */
@property (nonatomic, assign, readonly) HNKGooglePlacesAutocompleteLocation location;

/**
 *  The position, in the input term, of the last character that the
 *  service uses to match predictions
 *
 *  @discussion: For example, if the input is 'Google' and the offset
 *  is 3, the service will match on 'Goo'. The string determined by the
 *  offset is matched against the first word in the input term only.
 *  For example, if the input term is 'Google abc' and the offset is 3,
 *  the service will attempt to match against 'Goo abc'.
 */
@property (nonatomic, assign, readonly) NSInteger offset;

/**
 *  The distance (in meters) within which place results are returned
 *
 *  Note: Results will be biased to the indicated area, but may not
 *  be fully restricted to the specified area
 */
@property (nonatomic, assign, readonly) NSInteger searchRadius;

#pragma mark - Initialization

/**
 *  Returns HNKGooglePlacesAutocompleteQueryConfig instance with provided
 *  configuration properties
 *
 *  To not specify a specific offset or searchRadius, set these values to
 *  NSNotFound respectively
 *
 *  Note: This is the designated initializer
 */
- (instancetype)initWithCountry:(NSString *)country filter:(HNKGooglePlaceTypeAutocompleteFilter)filter language:(NSString *)language location:(HNKGooglePlacesAutocompleteLocation)location  offset:(NSInteger)offset searchRadius:(NSInteger)searchRadius;

#pragma mark - Instance methods

/**
 *  Translation of properties into parameter dictionary for
 *  requests to Google Places API
 */
- (NSDictionary *)translateToServerRequestParameters;

@end
