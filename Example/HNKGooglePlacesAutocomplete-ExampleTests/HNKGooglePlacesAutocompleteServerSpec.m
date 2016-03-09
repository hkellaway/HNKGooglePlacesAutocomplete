//
//  HNKGooglePlacesServerSpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/28/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesServer.h>

SPEC_BEGIN(HNKGooglePlacesServerSpec)

describe(@"HNKGooglePlacesServer", ^{

    describe(@"Method: initialize",
             ^{
                 __block id mockHTTPSessionManager;
                 
                 beforeEach(^{
                     
                     mockHTTPSessionManager = [AFHTTPSessionManager nullMock];
                    
                     [AFHTTPSessionManager stub:@selector(alloc) andReturn:mockHTTPSessionManager];
                     
                 });

                 it(@"Should setup AFHTTPSessionManager",
                    ^{
                        [[mockHTTPSessionManager should] receive:@selector(initWithBaseURL:) withArguments:[NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/"]];

                        [HNKGooglePlacesServer initialize];
                    });
             });

});

SPEC_END