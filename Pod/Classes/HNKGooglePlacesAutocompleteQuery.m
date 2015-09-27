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
#import "HNKGooglePlacesServer.h"
#import "HNKGooglePlacesAutocompleteQueryResponse.h"

#pragma mark Error Constants

NSString *const HNKGooglePlacesAutocompleteQueryErrorDomain = @"com.hnkgoogleplacesautocomplete.query.fetch.error";

#pragma mark Request Constants

static NSString *const kHNKGooglePlacesServerRequestPathAutocomplete = @"autocomplete/json";

#pragma mark Status Constants

static NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionUnknown = @"Status unknown";
static NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionInvalidRequest =
    @"Invalid request. The input parameter may be missing.";
static NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionOK =
    @"No errors occurred and at least one result was returned.";
static NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionOverQueryLimit =
    @"Query quota has been exceeded for provided API key.";
static NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionRequestDenied =
    @"Request denied. The key parameter may be invalid.";
static NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionZeroResults =
    @"No errors occurred but no results were returned.";
static NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionServerRequestFailed =
    @"Non-API error occurred while making a request to the server.";
static NSString *const HNKGooglePlacesAutocompleteQueryStatusDescriptionSearchQueryNil = @"Search query cannot be nil.";

#pragma mark Enums

typedef NS_ENUM(NSInteger, HNKGooglePlacesAutocompleteQueryType) {
    HNKGooglePlacesAutocompleteQueryTypeValid,
    HNKGooglePlacesAutocompleteQueryTypeEmpty,
    HNKGooglePlacesAutocompleteQueryTypeNil
};

@interface HNKGooglePlacesAutocompleteQuery ()

@property (nonatomic, copy, readwrite) NSString *apiKey;
@property (nonatomic, strong, readwrite) HNKGooglePlacesAutocompleteQueryConfig *configuration;

@end

@implementation HNKGooglePlacesAutocompleteQuery

#pragma mark - Initialization

static HNKGooglePlacesAutocompleteQuery *sharedQuery = nil;

+ (instancetype)setupSharedQueryWithAPIKey:(NSString *)apiKey
{
    return [self setupSharedQueryWithAPIKey:apiKey configurationBlock:nil];
}

+ (instancetype)setupSharedQueryWithAPIKey:(NSString *)apiKey
                        configurationBlock:(HNKGooglePlacesAutocompleteQueryConfigBlock)configBlock
{
    NSParameterAssert(apiKey);

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken,
                  ^{
                      sharedQuery = [[self alloc] initWithAPIKey:apiKey configurationBlock:configBlock];
                  });

    return sharedQuery;
}

+ (instancetype)sharedQuery
{
    NSAssert(sharedQuery != nil, @"sharedQuery should not be called before setupSharedQueryWithAPIKey");

    return sharedQuery;
}

- (instancetype)init
{
    NSAssert(FALSE, @"-init should not be called. Use -setupWithAPIKey");

    return nil;
}

- (instancetype)initWithAPIKey:(NSString *)apiKey
            configurationBlock:(void (^)(HNKGooglePlacesAutocompleteQueryConfig *))configBlock
{
    self = [super init];

    if (self) {

        self.apiKey = apiKey;

        self.configuration = [HNKGooglePlacesAutocompleteQueryConfig defaultConfig];

        if (configBlock) {

            configBlock(self.configuration);
        }
    }

    return self;
}

#pragma mark - Requests

- (void)fetchPlacesForSearchQuery:(NSString *)searchQuery
                       completion:(HNKGooglePlacesAutocompleteQueryCallback)completion
{
    [self fetchPlacesForSearchQuery:searchQuery
                 configurationBlock:^(HNKGooglePlacesAutocompleteQueryConfig *config) {

                     if (self.configuration == nil) {

                         config = self.configuration;
                     }

                 } completion:completion];
}

- (void)fetchPlacesForSearchQuery:(NSString *)searchQuery
               configurationBlock:(HNKGooglePlacesAutocompleteQueryConfigBlock)configBlock
                       completion:(HNKGooglePlacesAutocompleteQueryCallback)completion
{
    HNKGooglePlacesAutocompleteQueryConfig *configForRequest =
        [HNKGooglePlacesAutocompleteQueryConfig configWithConfig:self.configuration];

    if (configBlock) {
        configBlock(configForRequest);
    }
    
    if ([self shouldMakeServerRequestForSearchQuery:searchQuery]) {
        
        HNKGooglePlacesAutocompleteQueryType searchQueryType = [self searchQueryTypeForSearchQuery:searchQuery];
        
        if (searchQueryType == HNKGooglePlacesAutocompleteQueryTypeValid) {
            
            [self serverRequestWithSearchQuery:searchQuery configuration:configForRequest completion:completion];
        } else {
            
            [self completeWithErrorForInvalidSearchQueryOfType:searchQueryType completion:completion];
        }
    } else {
        if (completion) {
            completion(@[], nil);
        }
    }
}

#pragma mark - Helpers

- (BOOL)shouldMakeServerRequestForSearchQuery:(NSString *)searchQuery
{
    BOOL hasNoOffset = (self.configuration.offset == NSNotFound);
    BOOL doesMeetOffset = (searchQuery.length >= self.configuration.offset);

    return hasNoOffset || doesMeetOffset;
}

- (HNKGooglePlacesAutocompleteQueryType)searchQueryTypeForSearchQuery:(NSString *)searchQuery
{
    if (searchQuery == nil) {
        return HNKGooglePlacesAutocompleteQueryTypeNil;
    } else if ([searchQuery isEqualToString:@""]) {
        return HNKGooglePlacesAutocompleteQueryTypeEmpty;
    } else {
        return HNKGooglePlacesAutocompleteQueryTypeValid;
    }
}

- (void)serverRequestWithSearchQuery:(NSString *)searchQuery
                       configuration:(HNKGooglePlacesAutocompleteQueryConfig *)configuration
                          completion:(HNKGooglePlacesAutocompleteQueryCallback)completion
{
    NSDictionary *parameters = [self serverRequestParametersForSearchQuery:searchQuery configuration:configuration];

    [HNKGooglePlacesServer GET:kHNKGooglePlacesServerRequestPathAutocomplete
                    parameters:parameters
                    completion:^(NSDictionary *JSON, NSError *error) {

                        if (completion) {

                            if (error) {

                                [self completeWithServerError:error completion:completion];

                            } else {

                                [self completeWithServerResponse:JSON completion:completion];
                            }
                        }

                    }];
}

- (NSDictionary *)serverRequestParametersForSearchQuery:(NSString *)searchQuery
                                          configuration:(HNKGooglePlacesAutocompleteQueryConfig *)configuration
{
    NSMutableDictionary *parameters = [[configuration translateToServerRequestParameters] mutableCopy];

    [parameters addEntriesFromDictionary:@{ @"input" : searchQuery, @"key" : self.apiKey }];

    return [parameters copy];
}

- (void)completeWithServerResponse:(NSDictionary *)JSON completion:(HNKGooglePlacesAutocompleteQueryCallback)completion
{
    HNKGooglePlacesAutocompleteQueryResponse *queryResponse =
        [HNKGooglePlacesAutocompleteQueryResponse modelFromJSONDictionary:JSON];
    NSError *statusError = [self customErrorForErrorMessage:queryResponse.errorMessage status:queryResponse.status];

    if (statusError) {

        completion(nil, statusError);

    } else {

        completion(queryResponse.places, nil);
    }
}

- (void)completeWithServerError:(NSError *)error completion:(HNKGooglePlacesAutocompleteQueryCallback)completion
{
    HNKGooglePlacesAutocompleteQueryErrorCode errorCode = HNKGooglePlacesAutcompleteQueryErrorCodeServerRequestFailed;

    NSError *errorToReturn =
        [self customErrorWithCode:errorCode
                      description:HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(errorCode)
                      andUserInfo:@{
                          @"NSUnderlyingError" : error
                      }];

    completion(nil, errorToReturn);
}

- (void)completeWithErrorForInvalidSearchQueryOfType:(HNKGooglePlacesAutocompleteQueryType)type
                                          completion:(HNKGooglePlacesAutocompleteQueryCallback)completion
{
    if (type == HNKGooglePlacesAutocompleteQueryTypeNil) {
        [self completeForSearchQueryNil:completion];
    } else if (type == HNKGooglePlacesAutocompleteQueryTypeEmpty) {
        [self completeForSearchQueryEmpty:completion];
    } else {
        NSAssert(FALSE, @"Unknown invalid search query type.");
    }
}

- (void)completeForSearchQueryNil:(HNKGooglePlacesAutocompleteQueryCallback)completion
{
    HNKGooglePlacesAutocompleteQueryErrorCode errorCode = HNKGooglePlacesAutocompleteQueryErrorCodeSearchQueryNil;

    NSError *error = [self customErrorWithCode:errorCode
                                andDescription:HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(errorCode)];

    completion(nil, error);
}

- (void)completeForSearchQueryEmpty:(HNKGooglePlacesAutocompleteQueryCallback)completion
{
    NSError *error = [self customErrorForStatus:HNKGooglePlacesAutocompleteQueryResponseStatusInvalidRequest];

    completion(nil, error);
}

- (NSError *)customErrorForErrorMessage:(NSString *)errorMessage status:(HNKGooglePlacesAutocompleteQueryResponseStatus)status
{
    if (errorMessage && ![errorMessage isEqualToString:@""]) {
        return [self customErrorWithCode:status andDescription:errorMessage];
    } else {
        return [self customErrorForStatus:status];
    }
}

- (NSError *)customErrorForStatus:(HNKGooglePlacesAutocompleteQueryResponseStatus)status
{
    if (status == HNKGooglePlacesAutocompleteQueryResponseStatusInvalidRequest ||
        status == HNKGooglePlacesAutocompleteQueryResponseStatusOverQueryLimit ||
        status == HNKGooglePlacesAutocompleteQueryResponseStatusRequestDenied ||
        status == HNKGooglePlacesAutocompleteQueryResponseStatusUnknown) {

        HNKGooglePlacesAutocompleteQueryErrorCode errorCode = [self errorCodeForStatus:status];
        NSString *description = HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(errorCode);

        return [self customErrorWithCode:status andDescription:description];
    }

    return nil;
}

- (NSError *)customErrorWithCode:(NSInteger)errorCode andDescription:(NSString *)errorDescription
{
    return [self customErrorWithCode:errorCode description:errorDescription andUserInfo:nil];
}
- (NSError *)customErrorWithCode:(NSInteger)errorCode
                     description:(NSString *)errorDescription
                     andUserInfo:(NSDictionary *)userInfo
{
    NSDictionary *userInfoToReturn =
        @{ @"NSLocalizedDescription" : errorDescription,
           @"NSLocalizedFailureReason" : errorDescription };

    if (userInfo != nil) {
        NSMutableDictionary *mutableDictionary = [userInfoToReturn mutableCopy];
        [mutableDictionary addEntriesFromDictionary:userInfo];
        userInfoToReturn = [mutableDictionary copy];
    }

    return
        [NSError errorWithDomain:HNKGooglePlacesAutocompleteQueryErrorDomain code:errorCode userInfo:userInfoToReturn];
}

- (HNKGooglePlacesAutocompleteQueryErrorCode)errorCodeForStatus:(HNKGooglePlacesAutocompleteQueryResponseStatus)status
{
    switch (status) {
    case HNKGooglePlacesAutocompleteQueryResponseStatusUnknown: {
        return HNKGooglePlacesAutocompleteQueryErrorCodeUnknown;
        break;
    }
    case HNKGooglePlacesAutocompleteQueryResponseStatusInvalidRequest: {
        return HNKGooglePlacesAutocompleteQueryErrorCodeInvalidRequest;
        break;
    }
    case HNKGooglePlacesAutocompleteQueryResponseStatusOK: {
        return HNKGooglePlacesAutocompleteQueryErrorCodeUnknown;
        break;
    }
    case HNKGooglePlacesAutocompleteQueryResponseStatusOverQueryLimit: {
        return HNKGooglePlacesAutocompleteQueryErrorCodeOverQueryLimit;
        break;
    }
    case HNKGooglePlacesAutocompleteQueryResponseStatusRequestDenied: {
        return HNKGooglePlacesAutocompleteQueryErrorCodeRequestDenied;
        break;
    }
    case HNKGooglePlacesAutocompleteQueryResponseStatusZeroResults: {
        return HNKGooglePlacesAutocompleteQueryErrorCodeUnknown;
        break;
    }
    default: {
        return HNKGooglePlacesAutocompleteQueryErrorCodeUnknown;
        break;
    }
    }
}

NSString *HNKGooglePlacesAutocompleteQueryDescriptionForErrorCode(HNKGooglePlacesAutocompleteQueryErrorCode errorCode)
{
    switch (errorCode) {
    case HNKGooglePlacesAutocompleteQueryErrorCodeUnknown: {
        return HNKGooglePlacesAutocompleteQueryStatusDescriptionUnknown;
        break;
    }
    case HNKGooglePlacesAutocompleteQueryErrorCodeInvalidRequest: {
        return HNKGooglePlacesAutocompleteQueryStatusDescriptionInvalidRequest;
        break;
    }
    case HNKGooglePlacesAutocompleteQueryErrorCodeOverQueryLimit: {
        return HNKGooglePlacesAutocompleteQueryStatusDescriptionOverQueryLimit;
        break;
    }
    case HNKGooglePlacesAutocompleteQueryErrorCodeRequestDenied: {
        return HNKGooglePlacesAutocompleteQueryStatusDescriptionRequestDenied;
        break;
    }
    case HNKGooglePlacesAutcompleteQueryErrorCodeServerRequestFailed: {
        return HNKGooglePlacesAutocompleteQueryStatusDescriptionServerRequestFailed;
        break;
    }
    case HNKGooglePlacesAutocompleteQueryErrorCodeSearchQueryNil: {
        return HNKGooglePlacesAutocompleteQueryStatusDescriptionSearchQueryNil;
        break;
    }
    default: {
        return HNKGooglePlacesAutocompleteQueryStatusDescriptionUnknown;
        break;
    }
    }
}

@end
