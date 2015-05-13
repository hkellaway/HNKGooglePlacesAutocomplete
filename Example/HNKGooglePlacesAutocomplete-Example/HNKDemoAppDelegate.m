//
//  HNKDemoAppDelegate.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "HNKDemoAppDelegate.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQueryConfig.h>

static NSString *const kHNKDemoGooglePlacesAutocompleteApiKey = @"AIzaSyAkR80JQgRgfnqBl6Db2RsnmkCG1LhuVn8";
static double const kHNKLocationLatitudeNewYorkCity = 40.7127;
static double const kHNKLocationLongitudeNewYorkCity = 74.0059;

@interface HNKDemoAppDelegate ()

@end

@implementation HNKDemoAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    HNKGooglePlacesAutocompleteQueryConfig *searchConfig =
        [[HNKGooglePlacesAutocompleteQueryConfig alloc] initWithCountry:nil
                                                                 filter:HNKGooglePlaceTypeAutocompleteFilterAll
                                                               language:nil
                                                               latitude:kHNKLocationLatitudeNewYorkCity
                                                              longitude:kHNKLocationLongitudeNewYorkCity
                                                                 offset:NSNotFound
                                                           searchRadius:100];
    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey:kHNKDemoGooglePlacesAutocompleteApiKey
                                                   configuration:searchConfig];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of
    // temporary interruptions (such as an incoming phone call or SMS message) or
    // when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use
    // this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application
    // state information to restore your application to its current state in case
    // it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate:
    // when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes
    // made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application
    // was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if
    // appropriate. See also
    // applicationDidEnterBackground:.
}

@end
