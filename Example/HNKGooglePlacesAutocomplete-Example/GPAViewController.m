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

    NSDictionary *predictionJSON = @{
        @"description" : @"Victoria, BC, Canadá",
        @"id" : @"d5892cffd777f0252b94ab2651fea7123d2aa34a",
        @"matched_substrings" : @[ @{@"length" : @4, @"offset" : @0} ],
        @"place_id" : @"ChIJcWGw3Ytzj1QR7Ui7HnTz6Dg",
        @"reference" : @"CjQtAAAA903zyJZAu2FLA6KkdC7UAddRHAfHQDpArCk61FI_"
        @"u1Ig7WaJqBiXYsQvORYMcgILEhAFvGtwa5VQpswubIIzwI5wGhTt8vgj6CSQp8QWYb4U1rXmlkg9bg",
        @"terms" : @[
            @{@"offset" : @0, @"value" : @"Victoria"},
            @{@"offset" : @10, @"value" : @"BC"},
            @{@"offset" : @14, @"value" : @"Canadá"}
        ],
        @"types" : @[ @"locality", @"political", @"geocode" ]
    };
    HNKQueryResponsePrediction *prediction = [HNKQueryResponsePrediction modelFromJSONDictionary:predictionJSON];
    NSLog(@"prediction = %@", prediction);
}

@end
