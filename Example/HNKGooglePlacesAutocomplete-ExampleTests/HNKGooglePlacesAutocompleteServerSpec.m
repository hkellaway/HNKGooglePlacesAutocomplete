//
//  HNKGooglePlacesServerSpec.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/28/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesServer.h>
#import <HNKServerFacade/HNKServer.h>

SPEC_BEGIN(HNKGooglePlacesServerSpec)

describe(@"HNKGooglePlacesServer", ^{

    describe(@"Method: initialize",
             ^{
                 __block id mockServer;
                 
                 beforeEach(^{
                     
                     mockServer = [HNKServer nullMock];
                    
                     [HNKServer stub:@selector(alloc) andReturn:mockServer];
                     
                 });

                 it(@"Should setup HNKServer",
                    ^{
                        [[mockServer should] receive:@selector(initWithBaseURL:) withArguments:@"https://maps.googleapis.com/maps/api/place/"];

                        [HNKGooglePlacesServer initialize];
                    });
             });

});

SPEC_END