//
//  HNKQueryResponsePredictionTerm.m
//  Pods
//
//  Created by Harlan Kellaway on 4/26/15.
//
//

#import "HNKQueryResponsePredictionTerm.h"

@implementation HNKQueryResponsePredictionTerm

#pragma mark - Protocol conformance

#pragma mark <MTLJSONSerializing>

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{ @"offset" : @"offset", @"value" : @"value" };
}

@end
