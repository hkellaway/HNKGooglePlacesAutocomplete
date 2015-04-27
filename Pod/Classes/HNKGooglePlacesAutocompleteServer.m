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

static NSString *const kHNKServerBaseURL = @"https://maps.googleapis.com/maps/api/";

@interface HNKGooglePlacesAutocompleteServer ()

@property (nonatomic, strong) HNKServer *server;

@end

@implementation HNKGooglePlacesAutocompleteServer

#pragma mark - Initialization

static HNKGooglePlacesAutocompleteServer *sharedServer = nil;

+ (instancetype)sharedServer
{
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken,
                  ^{
                      sharedServer = [[self alloc] init];

                      [HNKServer setupWithBaseUrl:kHNKServerBaseURL];
                  });

    return sharedServer;
}

#pragma mark - Requests

- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(id JSON, NSError *))completion
{
    [HNKServer GET:path
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
