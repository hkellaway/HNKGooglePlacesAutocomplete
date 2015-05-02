//
//  HNKGooglePlacesAutocompleteServer.m
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

#import "HNKGooglePlacesAutocompleteServer.h"
#import "HNKServer.h"

static NSString *const kHNKGooglePlacesAutocompleteServerBaseURL =
    @"https://maps.googleapis.com/maps/api/";
static NSString *const kHNKGooglePlacesAutocompleteServerRequestPath =
    @"place/autocomplete/json";

@implementation HNKGooglePlacesAutocompleteServer

#pragma mark - Overrides

+ (void)initialize {
  if (self == [HNKGooglePlacesAutocompleteServer class]) {

    [HNKServer setupWithBaseUrl:kHNKGooglePlacesAutocompleteServerBaseURL];
  }
}

#pragma mark - Requests

+ (void)GET:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(void (^)(id, NSError *))completion {
  [HNKServer GET:kHNKGooglePlacesAutocompleteServerRequestPath
      parameters:parameters
      completion:^(id responseObject, NSError *error) {

        if (completion) {

          if (error) {
            completion(nil, error);
            return;
          }

          completion(responseObject, nil);
        }

      }];
}

@end
