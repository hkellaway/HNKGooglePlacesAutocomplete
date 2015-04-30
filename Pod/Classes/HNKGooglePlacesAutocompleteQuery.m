//
//  HNKGooglePlacesAutocompleteQuery.m
//  Pods
//
//  Created by Harlan Kellaway on 4/29/15.
//
//

#import "HNKGooglePlacesAutocompleteQuery.h"

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

@end
