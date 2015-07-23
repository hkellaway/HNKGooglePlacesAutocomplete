Pod::Spec.new do |s|
  s.name         = "HNKGooglePlacesAutocomplete"
  s.version      = "1.1.0"
  s.summary      = "An Objective-C wrapper for the Google Places Autocomplete API"
  s.description  = "An Objective-C wrapper for the GooglePlaces Autocomplete API. HNKGooglePlacesAutocomplete encapsulates the same core functionality as SPGooglePlacesAutocomplete - autocomplete suggestions and Google Place-to-CLPlacemark translation - with a more modern approach."
  s.homepage     = "https://github.com/hkellaway/HNKGooglePlacesAutocomplete"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Harlan Kellaway" => "hello@harlankellaway.com" }
  s.source       = { :git => "https://github.com/hkellaway/HNKGooglePlacesAutocomplete.git", :tag => s.version.to_s }
  
  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source_files  = 'Pod/Classes/HNKGooglePlacesAutocomplete.{h,m}', 'Pod/Classes/CLPlacemark+HNKAdditions.{h,m}'

  s.subspec 'Models' do |ss|

    ss.subspec 'Networking' do |sss|
      sss.source_files = 'Pod/Classes/HNKGooglePlacesServer.{h,m}'
    end

    ss.source_files = 'Pod/Classes/HNKGooglePlacesAutocompleteModel.{h,m}', 'Pod/Classes/HNKGooglePlacesAutocompleteQuery.{h,m}', 'Pod/Classes/HNKGooglePlacesAutocompleteQueryConfig.{h,m}', 'Pod/Classes/HNKGooglePlacesAutocompleteQueryResponse.{h,m}', 'Pod/Classes/HNKGooglePlacesAutocompletePlace.{h,m}', 'Pod/Classes/HNKGooglePlacesAutocompletePlaceSubstring.{h,m}', 'Pod/Classes/HNKGooglePlacesAutocompletePlaceTerm.{h,m}'
  end

  s.frameworks = 'CoreLocation'

  s.dependency "HNKServerFacade", "~> 0.3"
  s.dependency "Mantle", "~> 2.0"

end
