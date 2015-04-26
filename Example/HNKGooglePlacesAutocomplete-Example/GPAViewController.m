//
//  GPAViewController.m
//  HNKGooglePlacesAutocomplete-Example
//
//  Created by Harlan Kellaway on 4/26/15.
//  Copyright (c) 2015 Harlan Kellaway. All rights reserved.
//

#import "GPAViewController.h"

#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>

@interface GPAViewController ()

@end

@implementation GPAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSDictionary *predictionTermJSON = @{ @"offset" : @10, @"value" : @"BC" };
    HNKQueryResponsePredictionTerm *term = [HNKQueryResponsePredictionTerm modelFromJSONDictionary:predictionTermJSON];
    NSLog(@"term.offest = %ld, term.value = %@", (long)term.offset, term.value);

    NSDictionary *predictionMatchedSubstringJSON = @{ @"length" : @4, @"offset" : @0 };
    HNKQueryResponsePredictionMatchedSubstring *matchedSubstring =
        [HNKQueryResponsePredictionMatchedSubstring modelFromJSONDictionary:predictionMatchedSubstringJSON];
    NSLog(@"matchedSbustring.length = %ld, matchedSbustring.offset = %ld",
          (long)matchedSubstring.length,
          matchedSubstring.offset);
}

@end
