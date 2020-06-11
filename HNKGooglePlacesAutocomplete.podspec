Pod::Spec.new do |s|
  s.name         = "HNKGooglePlacesAutocomplete"
  s.version      = "1.2.0"
  s.summary      = "An Objective-C wrapper for the Google Places Autocomplete API"
  s.description  = "An Objective-C wrapper for the GooglePlaces Autocomplete API. HNKGooglePlacesAutocomplete encapsulates the same core functionality as SPGooglePlacesAutocomplete - autocomplete suggestions and Google Place-to-CLPlacemark translation - with a more modern approach."
  s.homepage     = "https://github.com/hkellaway/HNKGooglePlacesAutocomplete"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Harlan Kellaway" => "hello@harlankellaway.com" }
  s.source       = { :git => "https://github.com/hkellaway/HNKGooglePlacesAutocomplete.git", :tag => s.version.to_s }
  
  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.source_files  = 'Pod/Classes/*.{h,m}'

  s.dependency "AFNetworking", "~> 4.0"
  s.dependency "Mantle", "~> 2.0"

end
