//
//  HNKGooglePlacesServer.m
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

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "HNKGooglePlacesServer.h"

static NSString *const kHNKGooglePlacesServerBaseURL = @"https://maps.googleapis.com/maps/api/place/";

@implementation HNKGooglePlacesServer

#pragma mark - Overrides

static AFHTTPSessionManager *httpSessionManager = nil;

+ (void)initialize
{
    if (self == [HNKGooglePlacesServer class]) {

        httpSessionManager = [[AFHTTPSessionManager alloc]
                                   initWithBaseURL:[NSURL URLWithString:kHNKGooglePlacesServerBaseURL]];
    
        httpSessionManager.responseSerializer.acceptableContentTypes =
        [NSSet setWithObject:@"application/json"];
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    }
}

#pragma mark - Requests

+ (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(id, NSError *))completion
{
    NSString *urlString = [kHNKGooglePlacesServerBaseURL stringByAppendingPathComponent:path];
    
    [httpSessionManager GET:urlString parameters:parameters progress:^(NSProgress *downloadProgress) { } success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
            completion(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end
