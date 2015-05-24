//
//  HNKGooglePlacesAutocompleteQueryConfig.m
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

#import "HNKGooglePlacesAutocompleteQueryConfig.h"

@implementation HNKGooglePlacesAutocompleteQueryConfig

#pragma mark - Initialization

#pragma mark Convenience

+ (instancetype)configWithConfig:(HNKGooglePlacesAutocompleteQueryConfig *)config
{
    HNKGooglePlacesAutocompleteQueryConfig *newConfig = [[HNKGooglePlacesAutocompleteQueryConfig alloc] init];
    newConfig.country = config.country;
    newConfig.filter = config.filter;
    newConfig.language = config.language;
    newConfig.latitude = config.latitude;
    newConfig.longitude = config.longitude;
    newConfig.offset = config.offset;
    newConfig.searchRadius = config.searchRadius;

    return newConfig;
}

#pragma mark - Methods

- (NSDictionary *)translateToServerRequestParameters
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    if (self.country) {

        NSString *countryValue = [NSString stringWithFormat:@"country:%@", self.country];
        [parameters addEntriesFromDictionary:@{ @"components" : countryValue }];
    }

    if (self.language) {
        [parameters addEntriesFromDictionary:@{ @"language" : self.language }];
    }

    if (self.latitude != 0 && self.longitude != 0) {

        NSString *locationValue = [NSString stringWithFormat:@"%f,%f", self.latitude, self.longitude];
        [parameters addEntriesFromDictionary:@{ @"location" : locationValue }];
    }

    if (self.offset != NSNotFound) {
        [parameters addEntriesFromDictionary:@{ @"offset" : @(self.offset) }];
    }

    if (self.searchRadius != NSNotFound) {
        [parameters addEntriesFromDictionary:@{ @"radius" : @(self.searchRadius) }];
    }

    if (self.filter) {
        [parameters addEntriesFromDictionary:[self translateFilterToRequestParameter:self.filter]];
    }

    return parameters;
}

#pragma mark - Overrides

- (NSString *)description
{
    static NSString *noValue = @"N/A";

    NSString *country = self.country ? self.country : noValue;
    NSString *language = self.language ? self.language : noValue;
    NSString *location = (self.latitude == 0 && self.longitude == 0)
                             ? noValue
                             : [NSString stringWithFormat:@"(%f, %f)", self.latitude, self.longitude];
    NSString *offset = (self.offset == NSNotFound) ? noValue : [NSString stringWithFormat:@"%li", (long)self.offset];

    return [NSString stringWithFormat:@"<%@: %p> Country: %@; Filter: %li; " @"Language: %@; Location: %@; Offset: %@; "
                                      @"Search Radius: %li",
                                      NSStringFromClass([self class]),
                                      self,
                                      country,
                                      (long)self.filter,
                                      language,
                                      location,
                                      offset,
                                      (long)self.searchRadius];
}

#pragma mark - Helpers

- (NSDictionary *)translateFilterToRequestParameter:(HNKGooglePlaceTypeAutocompleteFilter)filter
{

    NSString *parameterKey = @"types";

    switch (filter) {
    case HNKGooglePlaceTypeAutocompleteFilterAll:
        return @{};
        break;
    case HNKGooglePlaceTypeAutocompleteFilterAddress:
        return @{ parameterKey : @"address" };
        break;
    case HNKGooglePlaceTypeAutocompleteFilterCity:
        return @{ parameterKey : @"(cities)" };
        break;
    case HNKGooglePlaceTypeAutocompleteFilterEstablishment:
        return @{ parameterKey : @"establishment" };
        break;
    case HNKGooglePlaceTypeAutocompleteFilterGeocode:
        return @{ parameterKey : @"geocode" };
        break;
    case HNKGooglePlaceTypeAutocompleteFilterRegion:
        return @{ parameterKey : @"(regions)" };
        break;
    default:
        return @{};
        break;
    }
}

@end
