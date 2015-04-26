//
//  HNKGooglePlacesAutocomplete_ExampleTests.m
//  HNKGooglePlacesAutocomplete-ExampleTests
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(ExampleSpec)

__block BOOL shouldPass;

beforeAll(^{

    shouldPass = YES;

});

describe(@"Example", ^{

    it(@"shouldPass",
       ^{
           [[theValue(shouldPass) should] equal:theValue(YES)];
       });
});

SPEC_END