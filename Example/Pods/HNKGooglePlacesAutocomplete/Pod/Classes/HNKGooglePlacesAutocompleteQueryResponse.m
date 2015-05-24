//
//  HNKGooglePlacesAutocompleteQueryResponse.m
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
#import "HNKGooglePlacesAutocompletePlace.h"

@implementation HNKGooglePlacesAutocompleteQueryResponse

#pragma mark - Protocol conformance

#pragma mark <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"places" : @"predictions", @"status" : @"status" };
}

+ (NSValueTransformer *)placesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[HNKGooglePlacesAutocompletePlace class]];
}

+ (NSValueTransformer *)statusJSONTransformer
{
    NSDictionary *statusesDictionary = @{
        @"INVALID_REQUEST" : @(HNKGooglePlacesAutocompleteQueryResponseStatusInvalidRequest),
        @"OK" : @(HNKGooglePlacesAutocompleteQueryResponseStatusOK),
        @"OVER_QUERY_LIMIT" : @(HNKGooglePlacesAutocompleteQueryResponseStatusOverQueryLimit),
        @"REQUEST_DENIED" : @(HNKGooglePlacesAutocompleteQueryResponseStatusRequestDenied),
        @"ZERO_RESULTS" : @(HNKGooglePlacesAutocompleteQueryResponseStatusZeroResults)
    };

    return [MTLValueTransformer transformerWithBlock:^(NSString *status) {
        return statusesDictionary[status];
    }];
}

@end
