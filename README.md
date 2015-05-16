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
- Core functionality is useable without requiring the CoreLocation framework
- Code is well-tested using Kiwi
- Example project does not use the deprecated UISearchDisplayController
- Modularly designed with Cocoapods in mind

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
* CoreLocation now optional - only if resolution to CLPlacemark is desired

### API Key

HNKGooglePlacesAutocomplete uses the [Google Places Autocomplete API]. You will need an API key for this service in order to use HNKGooglePlacesAutocomplete.

* Create a [Google Developer account]
* Once activated, find your API key on your [Settings] page

## Classes

### Core Classes

These classes form the core functionality of HNKGooglePlacesAutocomplete - the object used to query the API for Place suggestions and the resulting Place object

- `HNKGooglePlacesAutocompletePlaceQuery`
- `HNKGooglePlacesAutocompletePlace`

### Supporting Classes

These classes are part of or support the core functionality of HNKGooglePlacesAutocomplete

- `HNKGooglePlacesAutocompleteQueryConfig`
- `HNKGooglePlacesAutocompleteQueryResponse`
- `HNKGooglePlacesAutocompletePlaceSubstring`
- `HNKGooglePlacesAutocompletePlaceTerm`

### Categories

These categories add useful funtionality to the core of HNKGooglePlacesAutocomplete

- `CLPlacemark+HNKAdditions.h`

## Usage

### Setup

Requests cannot be made without first supplying `HNKGooglePlacesAutocomplete` with your Google Places Autocomplete API Key (see [API Key](#api-key)). Once your API key is obtained, you can setup `HNKGooglePlacesAutocomplete` for use by calling `setupSharedInstanceWithAPIKey` on `HNKGooglePlacesAutocompleteQuery` (typically within the `AppDelegate`):

```objective-c
[HNKGooglePlacesAutocompleteQuery sharedInstanceWithAPIKey:@"YOUR_API_KEY"];
```

You should replace `YOUR_API_KEY` with your Google Places Autocomplete API key.

### Queries

`HNKGooglePlacesAutocompleteQuery` is responsible for handling queries for Places. Once [Setup](#setup) is complete, queries can be made to `[HNKGooglePlacesAutocopmleteQuery sharedQuery]`.

#### fetchPlacesForSearchQuery:completion:

```objective-c
[[HNKGooglePlacesAutocomplete sharedQuery] fetchPlacesForSearchQuery:@"Vict" completion:^(NSArray *places, NSError *error)  {
    if (error) {
        NSLog(@"ERROR: %@", error);
    } else {
        for (HNKGooglePlacesAutocompletePlace *place in places) {
	        NSLog(@"%@", place);
		}
    }
}];
```

The `completion` block provides an array of `HNKGooglePlaceAutcompletePlace` objects when successful. If not successful, error information can be found in the `error` object.

### Other Topics

#### Configuring Queries (optional)

#### Query Errors

## Credits

HNKGooglePlacesAutocomplete was created by [Harlan Kellaway](http://harlankellaway.com) with inspiration from [SPGooglePlacesAutocomplete](https://github.com/spoletto/SPGooglePlacesAutocomplete)

## License & Terms

HNKGooglePlacesAutocomplete uses the Google Places Autocomplete API and is bound under [Google's Terms of Use]

HNKGooglePlacesAutocomplete is available under the MIT license. See the [LICENSE](https://raw.githubusercontent.com/hkellaway/HNKGooglePlacesAutocomplete/master/LICENSE) file for more info.
