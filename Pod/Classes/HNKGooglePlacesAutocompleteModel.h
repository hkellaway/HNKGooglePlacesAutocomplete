//
//  HNKGooglePlacesAutocompleteModel.h
//  HNKGooglePlacesAutocomplete
//
// Copyright (c) 2015 Harlan Kellaway
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <Mantle/Mantle.h>

@interface HNKGooglePlacesAutocompleteModel : MTLModel <MTLJSONSerializing>

#pragma mark - Deserialization

/**
 *  Deserializes a JSON array representing model objects into an array
 *  of objects
 *
 *  @param JSONArray JSON array representing model objects
 *
 *  @return Array of model objects
 *
 *  @warning Returns nil if an error occurs during deserialization
 */
+ (NSArray *)modelsArrayFromJSONArray:(NSArray *)JSONArray;

/**
 *  Deserializes a JSON dictionary representing one model object into an object
 *
 *  @param JSONDictionary JSON dictionary representing one model object
 *
 *  @return A model object
 *
 *  @warning Returns nil if an error occurs during deserialization
 */
+ (instancetype)modelFromJSONDictionary:(NSDictionary *)JSONDictionary;

@end
