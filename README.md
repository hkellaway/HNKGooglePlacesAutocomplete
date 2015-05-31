# HNKGooglePlacesAutocomplete

[![CocoaPods](https://img.shields.io/cocoapods/v/HNKGooglePlacesAutocomplete.svg)](http://cocoapods.org/pods/HNKGooglePlacesAutocomplete)
[![CocoaPods](https://img.shields.io/cocoapods/l/HNKGooglePlacesAutocomplete.svg)](https://raw.githubusercontent.com/hkellaway/HNKGooglePlacesAutocomplete/master/LICENSE)
[![CocoaPods](https://img.shields.io/cocoapods/p/HNKGooglePlacesAutocomplete.svg)](http://cocoapods.org/pods/HNKGooglePlacesAutocomplete)
[![Build Status](https://travis-ci.org/hkellaway/HNKGooglePlacesAutocomplete.svg?branch=master)](https://travis-ci.org/hkellaway/HNKGooglePlacesAutocomplete)

An Objective-C wrapper for the Google Places Autocomplete API

## Background

HNKGooglePlacesAutocomplete is an Objective-C wrapper for the Google Places Autocomplete API. It encapsulates the same core functionality as [SPGooglePlacesAutocomplete](https://github.com/spoletto/SPGooglePlacesAutocomplete) - autocomplete suggestions and Google Place-to-CLPlacemark translation - with the intention of modernizing the approach.

Improvements include:
- Modern, vetted pods utilized (AFNetworking, Mantle)
- Code is well-tested using Kiwi
- Documentation is thorough
- Designed for reusability and dissemination with Cocoapods

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

### API Key

HNKGooglePlacesAutocomplete uses the [Google Places Autocomplete API](https://developers.google.com/places/webservice/autocomplete). You will need an API key for this service in order to use HNKGooglePlacesAutocomplete.

* Create a [Google Developer account](https://developers.google.com/)
* Create a new Project
* Turn on the Places API
* Find your API key on your Project's API Credentials

### CoreLocation Framework

HNKGooglePlacesAutocomplete makes use of the `CoreLocation` framework. Make sure this framework is added in your Xcode settings.

## Classes

### Core Classes

These classes form the core functionality of HNKGooglePlacesAutocomplete

- `HNKGooglePlacesAutocompletePlaceQuery` - used to query the API for Place suggestions
- `HNKGooglePlacesAutocompletePlace` - Place object resulting from a Query

### Utilities

- `CLPlacemark+HNKAdditions.h` - provides translation from an `HNKGooglePlacesAutocompletePlace` to a `CLPlacemark`

## Usage

### Setup

Requests cannot be made without first supplying `HNKGooglePlacesAutocomplete` with your Google Places API Key (see [API Key](#api-key)). Once your API key is obtained, you can setup `HNKGooglePlacesAutocomplete` for use by calling `setupSharedQueryWithAPIKey` on `HNKGooglePlacesAutocompleteQuery` (typically within the `AppDelegate`):

#### `setupSharedQueryWithAPIKey:`

```objective-c
[HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey:@"YOUR_API_KEY"];
```

You should replace `YOUR_API_KEY` with your Google Places API key.

### Queries

`HNKGooglePlacesAutocompleteQuery` is responsible for handling queries for Places. Once [Setup](#setup) is complete, queries can be made to `[HNKGooglePlacesAutocopmleteQuery sharedQuery]`.

#### `fetchPlacesForSearchQuery:completion:`

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

### CLPlacemark from Place

HNKGooglePlacesAutocomplete comes with a category that facilitates translating `HNKGooglePlacesAutocompletePlace`s to `CLPlacemark`s - this is often used when placing pins on a Map. To translate a Place to a `CLPlacemark`, first include the proper header: `#import "CLPlacemark+HNKAdditions.h"`. Then call as follows:

#### `hnk_placemarkFromGooglePlace:apiKey:completion:`

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
You should replace `YOUR_API_KEY` with your Google Places API key; `hnk_placemarkFromGooglePlace` uses your API key to query the Google Place Details API if needed.

## Advanced Topics

The core functionality needed to use HNKGooglePlacesAutocomplete is described in [Setup](#setup), [Queries](#queries), [Places](#places), and [CLPlacemark from Place](#clplacemark-from-place). The following sections describe additional topics that may be of use in particular situations.

### Errors

Errors returned by HNKGooglePlacesAutocomplete have a domain that starts with `com.hnkgoogleplacesautocomplete`.

A short description of the error can be found in the `error` object's `localizedDescription` property. 

If the `error` has an underlying error, such as an error returned by `CLGeocoder`, it can be found in the `error` object's `userInfo` dictionary, under the `NSUnderlyingError` key.

### Advanced Query Topics

#### Querying with Optional Parameters

Optional parameters can be used to restrict the results returned by the Google Places API in certain ways.

* `HNKGooglePlacesAutocompleQueryConfig` - object used to supply optional parameter values for requests

Configuration properties include:

* `country` - the country within which to restrict results; must be a a two character, ISO 3166-1 Alpha-2 compatible country code, such as "fr" for France
* `filter` - an `HNKGooglePlacesTypeAutocompleteFilter` value that restricts results to specific [Place Types](https://developers.google.com/places/webservice/autocomplete#place_types)
* `language` - the language in which results should be expressed; must be one of [Google's supported domain languages](https://developers.google.com/maps/faq#languagesupport)
* `latitude` & `longitude` - the location to which results should be biased
* `offset` - how many characters are used in the request
* `searchRadius` - the distance in meters within which to bias results

##### `fetchPlacesForSearchQuery:configurationBlock:completion:`

In addition to [fetchPlacesForSearchQuery:completion:](#fetchplacesforsearchquerycompletion), `HNKGooglePlacesAutocompleteQuery` provides `fetchPlacesForSearchQuery:configurationBlock:completion:` to allow optional parameters to be applied to _individual_ Queries.

```objective-c
[[HNKGooglePlacesAutocomplete sharedQuery] fetchPlacesForSearchQuery:@"Amo"
	configurationBlock:(HNKGooglePlacesAutocompleteQueryConfig *config) {
		config.country = @"fr";
        config.filter = HNKGooglePlaceTypeAutocompleteFilterCity;
        config.language = @"pt";
	}
	completion:^(NSArray *places, NSError *error)  { 
		// Completion here 
	}
];
```
Any or all of the Query Configuration properties can be set in the `configurationBlock`. If not set, [default values](#default-query-configuration) will be used.

The example above specifies that the Places returned should be restricted to France, should be cities, and should be listed in Portuguese.

If a certain Query Configuration should be used for _every_ query, then _setup_ should include a Query Configuration, via [setupSharedQueryWithAPIKey:configurationBlock:](#setupsharedquerywithapikeyconfigurationblock).

#### Default Query Configuration

Every `HNKGooglePlacesAutocompleteQuery` has a `configuration` whether one is explicitly supplied or not. 

The default configuration values are: 

* `country` = `nil`
* `filter` = `HNKGooglePlacesTypeAutocompleteFilterAll` 
* `language` = `nil`
* `latitude` and `longitude` = `0` (Google's way of indicating no location bias)
* `offset` = `NSNotFound`
* `searchRadius` = `20000000` (Google's way of indicating no specific search radius) 

### Advanced Setup Topics

#### `setupSharedQueryWithAPIKey:configurationBlock:`

In addition to [setupSharedQueryWithAPIKey:](#setupsharedquerywithapikey), `HNKGooglePlacesAutocompleteQuery` provides `setupSharedQueryWithAPIKey:configurationBlock:` to specify [optional parameters](#querying-with-optional-parameters) to be applied to _every_ Query.

```objective-c
[HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey:@"YOUR_API_KEY"
	configurationBlock:(HNKGooglePlacesAutocompleteQueryConfig *config) {
		config.country = @"jp";
        config.filter = HNKGooglePlaceTypeAutocompleteFilterEstablishment;
        config.language = @"ru";
	}
];
```
The example above specifies that the Places returned from every Query should be restricted to Japan, should be business establishments, and should be listed in Russian.

### Advanced Place Topics

#### Place Substrings

* `HNKGooglePlacesAutocompletePlaceSubstring`

`HNKGooglePlacesAutocompletePlace` objects have an array of `substrings` that describe the location of the entered term in the prediction result text - this is useful if the application is to highlight the user's query text in the result Place suggestions. 

For example, if a user typed "Amoeba" and a resulting Place suggestion had a `name` of "Amoeba Music, Telegraph Avenue, Berkeley, CA, United States", the `substrings` array would contain one entry indicating that the phrase "Amoeba" was in that `name` from character 0 to 6.

#### Place Terms

* `HNKGooglePlacesAutocompletePlaceTerm`

HNKGooglePlacesAutocompletePlace` objects have an array of `terms` that identify sections of the returned `name`. 

For example, if a user types "Amoeba" and a resulting Place suggestion had a `name` of "Amoeba Music, Telegraph Avenue, Berkeley, CA, United States", the `terms` array would contain entries indicating that the `name` was composed of the terms "Amoeba Music", "Telegraph Avenue", "Berkeley", "CA", and "United States".

## Transitioning from SPGooglePlacesAutocomplete

`TODO`

## Credits

HNKGooglePlacesAutocomplete was created by [Harlan Kellaway](http://harlankellaway.com). It was inspired by [SPGooglePlacesAutocomplete](https://github.com/spoletto/SPGooglePlacesAutocomplete).

## License & Terms

HNKGooglePlacesAutocomplete uses the Google Places API and is bound under [Google's Places API Policies](https://developers.google.com/places/webservice/policies)

HNKGooglePlacesAutocomplete is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hkellaway/HNKGooglePlacesAutocomplete/master/LICENSE) file for more info.
