//
//  HNKGooglePlacesAutocompleteQuery.h
//  Pods
//
//  Created by Harlan Kellaway on 4/29/15.
//
//

#import <Foundation/Foundation.h>

@interface HNKGooglePlacesAutocompleteQuery : NSObject

#pragma mark - Initialization

/**
 *  Sets up shared HNKGooglePlacesAutocompleteQuery instance with provided API key
 */
+ (instancetype)setupSharedQueryWithAPIKey:(NSString *)apiKey;

/**
 * Returns shared HNKGooglePlacesAutocompleteQuery instance
 *
 * Note: Should only be called after sharedSharedQueryWithAPIKey:
 */
+ (instancetype)sharedQuery;

@end
