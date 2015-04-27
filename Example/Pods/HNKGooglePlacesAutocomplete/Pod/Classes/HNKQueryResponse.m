//
//  HNKQueryResponse.m
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
#import "HNKQueryResponsePrediction.h"

@implementation HNKQueryResponse

#pragma mark - Protocol conformance

#pragma mark <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{ @"predictions" : @"predictions", @"status" : @"status" };
}

+ (NSValueTransformer *)predictionsJSONTransformer {
  return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:
                                 [HNKQueryResponsePrediction class]];
}

+ (NSValueTransformer *)statusJSONTransformer {
  NSDictionary *statusesDictionary = @{
    @"INVALID_REQUEST" : @(HNKQueryResponseStatusInvalidRequest),
    @"OK" : @(HNKQueryResponseStatusOK),
    @"OVER_QUERY_LIMIT" : @(HNKQueryResponseStatusOverQueryLimit),
    @"REQUEST_DENIED" : @(HNKQueryResponseStatusRequestDenied),
    @"ZERO_RESULTS" : @(HNKQueryResponseStatusZeroResults)
  };

  return [MTLValueTransformer transformerWithBlock:^(NSString *status) {
    return statusesDictionary[status];
  }];
}

@end
