//
//  HNKGooglePlacesAutocompleteQuery.m
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

#import "HNKGooglePlacesAutocompleteQuery.h"
#import "HNKGooglePlacesAutocompleteServer.h"
#import "HNKQueryResponse.h"

NSString *const HNKGooglePlacesAutocompleteQueryErrorDomain =
    @"com.hnkgoogleplacesautocomplete.query.fetch.error";
static NSString *const kHNKGooglePlacesAutocompleteServerRequestPath =
    @"place/autocomplete/json";

@interface HNKGooglePlacesAutocompleteQuery ()

@property(nonatomic, strong) NSString *apiKey;

@end

@implementation HNKGooglePlacesAutocompleteQuery

#pragma mark - Initialization

static HNKGooglePlacesAutocompleteQuery *sharedQuery = nil;

+ (instancetype)setupSharedQueryWithAPIKey:(NSString *)apiKey {
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    sharedQuery = [[self alloc] initWithAPIKey:apiKey];
  });

  return sharedQuery;
}

+ (instancetype)sharedQuery {
  NSAssert(
      sharedQuery != nil,
      @"sharedQuery should not be called before setupSharedQueryWithAPIKey");

  return sharedQuery;
}

- (instancetype)initWithAPIKey:(NSString *)apiKey {
  self = [super init];

  if (self) {
    self.apiKey = apiKey;
  }

  return self;
}

- (instancetype)init {
  NSAssert(FALSE, @"init should not be called");

  return [self initWithAPIKey:@""];
}

#pragma mark - Requests

- (void)fetchPlacesForSearchQuery:(NSString *)searchQuery
                       completion:(void (^)(NSArray *, NSError *))completion {
  [HNKGooglePlacesAutocompleteServer
             GET:kHNKGooglePlacesAutocompleteServerRequestPath
      parameters:@{
        @"input" : searchQuery,
        @"key" : self.apiKey,
        @"radius" : @500
      }
      completion:^(NSDictionary *JSON, NSError *error) {

        if (completion) {

          if (error) {
            NSError *errorToReturn = [NSError
                errorWithDomain:HNKGooglePlacesAutocompleteQueryErrorDomain
                           code:-1
                       userInfo:@{
                         @"NSUnderlyingErrorKey" : error
                       }];

            completion(nil, errorToReturn);
            return;
          }

          HNKQueryResponse *queryResponse =
              [HNKQueryResponse modelFromJSONDictionary:JSON];

          NSError *statusError = [self errorForStatus:queryResponse.status];

          if (statusError) {
            completion(nil, statusError);
            return;
          }

          completion(queryResponse.predictions, nil);
        }

      }];
}

#pragma mark - Helpers

- (NSError *)errorForStatus:(HNKQueryResponseStatus)status {
  if (status == HNKQueryResponseStatusInvalidRequest ||
      status == HNKQueryResponseStatusOverQueryLimit ||
      status == HNKQueryResponseStatusRequestDenied ||
      status == HNKQueryResponseStatusUnknown) {
    // TODO: Provide NSLocalizedDescriptionKey and
    // NSLocalizedFailureReasonErrorKey with description of error
    NSError *error =
        [NSError errorWithDomain:HNKGooglePlacesAutocompleteQueryErrorDomain
                            code:status
                        userInfo:nil];
    return error;
  }

  return nil;
}

@end
