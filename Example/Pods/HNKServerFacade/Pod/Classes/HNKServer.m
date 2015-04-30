//
//  HNKServer.m
//  HNKServerFacade
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

#import "HNKServer.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@implementation HNKServer

#pragma mark - Initialization

static NSString *baseURLStr = nil;
static AFHTTPSessionManager *httpSessionManager = nil;

+ (void)setupWithBaseUrl:(NSString *)baseURLString {
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    NSParameterAssert(baseURLString);

    baseURLStr = [[NSURL URLWithString:baseURLString] absoluteString];

    [self setupHttpSessionManager];
    [self setupNetworkActivityIndicator];
  });
}

#pragma mark - Class methods

+ (NSString *)baseURLString {
  return baseURLStr;
}

+ (BOOL)isNetworkActivityIndicatorEnabled {
  return [AFNetworkActivityIndicatorManager sharedManager].isEnabled;
}

+ (NSSet *)responseContentTypes {
  return httpSessionManager.responseSerializer.acceptableContentTypes;
}

#pragma mark Configuration

+ (void)configureResponseContentTypes:(NSSet *)newContentTypes {
  NSParameterAssert(newContentTypes);

  httpSessionManager.responseSerializer.acceptableContentTypes =
      newContentTypes;
}

#pragma mark Requests

+ (void)GET:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(void (^)(id responseObject, NSError *))completion {
  NSString *urlString = [self urlStringFromPath:path];

  [httpSessionManager GET:urlString
      parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
        if (completion) {
          completion(responseObject, nil);
        }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (completion) {
          completion(nil, error);
        }
      }];
}

#pragma mark - Helpers

+ (void)setupHttpSessionManager {
  if (httpSessionManager == nil) {
    httpSessionManager = [[AFHTTPSessionManager alloc]
        initWithBaseURL:[NSURL URLWithString:baseURLStr]];
  }

  httpSessionManager.responseSerializer.acceptableContentTypes =
      [NSSet setWithObject:@"application/json"];
}

+ (void)setupNetworkActivityIndicator {
  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

+ (NSString *)urlStringFromPath:(NSString *)path {
  return [baseURLStr stringByAppendingPathComponent:path];
}

@end
