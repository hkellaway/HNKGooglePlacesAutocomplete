# HNKGooglePlacesAutocomplete

[![CocoaPods](https://img.shields.io/cocoapods/v/HNKGooglePlacesAutocomplete.svg)](http://cocoapods.org/pods/HNKGooglePlacesAutocomplete)
[![CocoaPods](https://img.shields.io/cocoapods/l/HNKGooglePlacesAutocomplete.svg)](https://raw.githubusercontent.com/hkellaway/HNKGooglePlacesAutocomplete/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/p/HNKGooglePlacesAutocomplete.svg)](http://cocoapods.org/pods/HNKGooglePlacesAutocomplete)
[![Build Status](https://travis-ci.org/hkellaway/HNKGooglePlacesAutocomplete.svg?branch=master)](https://travis-ci.org/hkellaway/HNKGooglePlacesAutocomplete)

An Objective-C wrapper for the Google Places Autocomplete API

## Background

HNKGooglePlacesAutocomplete is an Objective-C wrapper for the Google Places Autocomplete API. It was inspired by [SPGooglePlacesAutocomplete](https://github.com/spoletto/SPGooglePlacesAutocomplete) with the intention of modernizing the implementation. HNKGooglePlacesAutocomplete encapsulates the same core functionality - Google Place Autocomplete suggestions and Google Place-to-CLPlacemark translation - with a more layered and pod-first approach.

Improvements include:
- Use of modern, vetted pods (AFNetworking, Mantle)
- Code is well-tested using Kiwi
- Example project does not use the deprecated UISearchDisplayController
- Designed with reusability and Cocoapods in mind

## Communication

- If you **have found a bug**, _and can provide steps to reliably reproduce it_, [open an issue](https://github.com/hkellaway/HNKGooglePlacesAutocomplete/issues/new).
- If you **have a feature request**, [open an issue](https://github.com/hkellaway/HNKGooglePlacesAutocomplete/issues/new).
- If you **want to contribute**, [submit a pull request](https://github.com/hkellaway/HNKGooglePlacesAutocomplete/pulls).

## Getting Started

- [Download HNKGooglePlacesAutocomplete](https://github.com/hkellaway/HNKGooglePlacesAutocomplete/archive/master.zip) and try out the included iOS example app
- Check out the [documentation](http://cocoadocs.org/docsets/HNKGooglePlacesAutocomplete/) for a more comprehensive look at the classes available in HNKGooglePlacesAutocomplete

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like HNKGooglePlacesAutocomplete in your projects. Cocoapods is the preferred way to incorporate HNKGooglePlacesAutocomplete in your project; if you are unfamiliar with how to install Cocoapods or how create a Podfile, there are many tutorials online.

#### Podfile

```ruby
pod "HNKGooglePlacesAutocomplete", "~> 1.0"
```

## Transitioning from SPGooglePlacesAutocomplete

* Link to Demo V1

### API Key

HNKGooglePlacesAutocomplete uses the [Google Places Autocomplete API](https://developers.google.com/places/webservice/autocomplete). You will need an API key for this service in order to use HNKGooglePlacesAutocomplete.

* Create a [Google Developer account](https://developers.google.com/)
* Create a new Project
* Turn on the Places API
* Find your API key on your Project's API Credentials

## Classes

### Core Classes

These classes form the core functionality of HNKGooglePlacesAutocomplete

- `HNKGooglePlacesAutocompletePlaceQuery` - used to query the API for Place suggestions
- `HNKGooglePlacesAutocompletePlace` - Place object resulting from a Query

### Supporting Classes

These classes are part of or support the core functionality of HNKGooglePlacesAutocomplete

- `HNKGooglePlacesAutocompleteQueryConfig` - used to configure _optional_ Query parameters (See: [Querying with Optional Parameters](#querying-with-optional-parameters))
- `HNKGooglePlacesAutocompletePlaceSubstring` - See: [Place Substrings](#place-substrings)
- `HNKGooglePlacesAutocompletePlaceTerm` - See: [Place Terms](#place-terms)

### Utilities

- `CLPlacemark+HNKAdditions.h` - provides translation from a Place object to a `CLPlacemark`

## Usage

### Setup

Requests cannot be made without first supplying `HNKGooglePlacesAutocomplete` with your Google Places API Key (see [API Key](#api-key)). Once your API key is obtained, you can setup `HNKGooglePlacesAutocomplete` for use by calling `setupSharedInstanceWithAPIKey` on `HNKGooglePlacesAutocompleteQuery` (typically within the `AppDelegate`):

```objective-c
[HNKGooglePlacesAutocompleteQuery sharedInstanceWithAPIKey:@"YOUR_API_KEY"];
```

You should replace `YOUR_API_KEY` with your Google Places API key.

### Queries

`HNKGooglePlacesAutocompleteQuery` is responsible for handling queries for Places. Once [Setup](#setup) is complete, queries can be made to `[HNKGooglePlacesAutocopmleteQuery sharedQuery]`.

#### fetchPlacesForSearchQuery:completion:

```objective-c
[[HNKGooglePlacesAutocomplete sharedQuery] fetchPlacesForSearchQuery:@"Amoeba" 
	completion:^(NSArray *places, NSError *error)  {
    	if (error) {
        	NSLog(@"ERROR: %@", error);
    	} else {
        	for (HNKGooglePlacesAutocompletePlace *place in places) {
	        	NSLog(@"%@", place);
			}
    	}
    }
];
```

The `completion` block provides an array of `HNKGooglePlaceAutcompletePlace` objects when successful. If not successful, error information can be found in the `error` object.

### Places

`HNKGooglePlacesAutocompletePlace` objects are returned from Queries and represent the suggested Places for that Query.

### CLPlacemark from Google Place

HNKGooglePlacesAutocomplete comes with a category that facilitates translating Places to `CLPlacemarks` - this is often used when placing pins on a Map. To translate a Place to a `CLPlacemark`, first include the proper header: `#import "CLPlacemark+HNKAdditions.h"`. Then call as follows:

#### hnk_placemarkFromGooglePlace:apiKey:completion:

```objective-c
[CLPlacemark hnk_placemarkFromGooglePlace:place
	apiKey:YOUR_API_KEY
  	completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
    	if(error) {
    		NSLog(@"ERROR: %@", error);
    	} else {
    		NSLog(@"PLACEMARK: %@", placemark);
    	}
    }
];
```
You should replace YOUR_API_KEY with your Google Places API key; `hnk_placemarkFromGooglePlace` uses your API key to query the Google Place Details API if needed.

### Advanced Topics

The core functionality needed to use HNKGooglePlacesAutocomplete is described in [Setup](#setup), [Queries](#queries), and [Places](#places). The following sections describe additional topics that may be of use in particular situations.

#### Advanced Setup Topics

#### Advanced Query Topics

##### Querying with Optional Parameters

###### Query Configuration

* `HNKGooglePlacesAutocompleQueryConfig` - object used to supply optional parameter values for requests

Requests can include the following optional configuration parameters:

* `country` - the country within which to restrict results; must be a a two character, ISO 3166-1 Alpha-2 compatible country code, such as "fr" for France
* `filter` - an HNKGooglePlacesTypeAutocompleteFilter value that restricts results to specific [Place Types](https://developers.google.com/places/webservice/autocomplete#place_types)
* `language` - the language in which results should be expressed; must be one of [Google's supported domain languages](https://developers.google.com/maps/faq#languagesupport)
* `latitude` & `longitude` - the location to which results should be biased
* `offset` - the position in the input term of the last character that the service uses to match predictions; i.e. if the input is "Google" and the offset is 3, the service will match on "Goo"
* `searchRadius` - the distance in meters within which to bias place results

Every `HNKGooglePlacesAutocompleteQuery` has a `configuration` whether one is supplied or not. The default configuration values are: `country` = `nil`, `filter` = `HNKGooglePlacesTypeAutocompleteFilterAll`, `language` = `nil`, `latitude` and `longitude` = `0` (Google's way of indicating no location bias), `offset` = `NSNotFound`, and `searchRadius` = `20000000` (Google's way of indicating no specific search radius) 

###### fetchPlacesForSearchQuery:configurationBlock:completion:

In addition to [fetchPlacesForSearchQuery:completion:](#fetchplacesforsearchquerycompletion), `HNKGooglePlacesAutocompleteQuery` provides `fetchPlacesForSearchQuery:configurationBlock:completion:` to _allow optional parameters to be applied to individual Queries_.

```objective-c
[[HNKGooglePlacesAutocomplete sharedQuery] fetchPlacesForSearchQuery:@"Amoeba"
	configurationBlock:(HNKGooglePlacesAutocompleteQueryConfig *config) {
		config.country = nil;
        config.filter = HNKGooglePlaceTypeAutocompleteFilterAll;
        config.language = nil;
        config.latitude = kHNKLocationLatitudeNewYorkCity;
        config.longitude = kHNKLocationLongitudeNewYorkCity;
        config.offset = NSNotFound;
        config.searchRadius = 100;
	}
	completion:^(NSArray *places, NSError *error)  {
    	if (error) {
        	NSLog(@"ERROR: %@", error);
    	} else {
        	for (HNKGooglePlacesAutocompletePlace *place in places) {
	        	NSLog(@"%@", place);
			}
    	}
    }
];
```

##### Query Errors

#### Advanced Place Topics

##### Place Substrings

Places contain an array of `substrings` that describe the location of the entered term in the prediction result text - this is useful if the application is to highlight the user's query text in the result Place suggestions. For example, if a user typed "Amoeba" and a resulting Place suggestion had a `name` of "Amoeba Music, Telegraph Avenue, Berkeley, CA, United States", the `substrings` array would contain one entry indicating that the phrase "Amoeba" was in that `name` from character 0 to 6.


Place substrings are represented by `HNKGooglePlacesAutocompletePlaceSubstring` objects.

##### Place Terms

Places contain an array of `terms` that identify sections of the returned `name`. For example, if a user types "Amoeba" and a resulting Place suggestion had a `name` of "Amoeba Music, Telegraph Avenue, Berkeley, CA, United States", the `terms` array would contain entries indicating that the `name` was composed of the terms "Amoeba Music", "Telegraph Avenue", "Berkeley", "CA", and "United States".

Place terms are represented by `HNKGooglePlacesAutocompletePlaceTerm` objects.

## Credits

HNKGooglePlacesAutocomplete was created by [Harlan Kellaway](http://harlankellaway.com) with inspiration from [SPGooglePlacesAutocomplete](https://github.com/spoletto/SPGooglePlacesAutocomplete)

## License & Terms

HNKGooglePlacesAutocomplete uses the Google Places API and is bound under [Google's Terms of Use]

HNKGooglePlacesAutocomplete is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hkellaway/HNKGooglePlacesAutocomplete/master/LICENSE) file for more info.
