//
//  HNKGooglePlacesNetworkingManager.h
//  Pods
//
//  Created by Harlan Kellaway on 11/23/15.
//
//

#import <Foundation/Foundation.h>

@protocol HNKGooglePlacesNetworkingManager <NSObject>

/**
 *  Performs a GET request to the Server
 *
 *  @param path       Path to GET from
 *  @param parameters Request parameters
 *  @param completion Block to be executed when the request finishes
 */
+ (void)GET:(NSString *)path
 parameters:(NSDictionary *)parameters
 completion:(void (^)(id JSON, NSError *error))completion;

@end
