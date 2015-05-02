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

#pragma mark Request Path

static NSString *const kHNKGooglePlacesAutocompleteServerRequestPath =
    @"place/autocomplete/json";

#pragma mark Error Constants

NSString *const HNKGooglePlacesAutocompleteQueryErrorDomain =
    @"com.hnkgoogleplacesautocomplete.query.fetch.error";

static NSString *const
    kHNKGooglePlacesAutocompleteQueryStatusUnknownDescription =
        @"Status unknown";
static NSString *const
    kHNKGooglePlacesAutocompleteQueryStatusInvalidRequestDescription =
        @"Invalid request; the input parameter may be missing";
static NSString *const kHNKGooglePlacesAutocompleteQueryStatusOKDescription =
    @"No errors occurred and at least one result was returned";
static NSString *const
    kHNKGooglePlacesAutocompleteQueryStatusOverQueryLimitDescription =
        @"Query quota has been exceeded for provided API key";
static NSString *const
    kHNKGooglePlacesAutocompleteQueryStatusRequestDeniedDescription =
        @"Request denied; the key parameter may be invalid";
static NSString *const
    kHNKGooglePlacesAutocompleteQueryStatusZeroResultsDescription =
        @"No errors occurred but no results were returned";
static NSString *const
    kHNKGooglePlacesAutocompleteQueryStatusSerchQueryNilDescription =
        @"Search query cannot be nil";

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
  if (searchQuery == nil) {
    NSError *error = [NSError
        errorWithDomain:HNKGooglePlacesAutocompleteQueryErrorDomain
                   code:HNKgooglePlacesAutocompleteQueryErrorCodeSearchQueryNil
               userInfo:@{
                 @"NSLocalizedDescriptionKey" :
                     kHNKGooglePlacesAutocompleteQueryStatusSerchQueryNilDescription,
                 @"NSLocalizedFailureReasonErrorKey" :
                     kHNKGooglePlacesAutocompleteQueryStatusSerchQueryNilDescription
               }];

    completion(nil, error);
    return;
  }

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
                           code:
                               HNKGooglePlacesAutcompleteQueryErrorCodeServerRequestFailed
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

    NSString *localizedDescription = [self errorDescriptionForStatus:status];
    NSError *error = [NSError
        errorWithDomain:HNKGooglePlacesAutocompleteQueryErrorDomain
                   code:status
               userInfo:@{
                 @"NSLocalizedDescriptionKey" : localizedDescription,
                 @"NSLocalizedFailureReasonErrorKey" : localizedDescription
               }];
    return error;
  }

  return nil;
}

- (NSString *)errorDescriptionForStatus:(HNKQueryResponseStatus)status {
  return @"Invalid request; the input parameter may be missing";
}

@end
