Pod::Spec.new do |s|
  s.name         = "HNKGooglePlacesAutocomplete"
  s.version      = "0.2.0"
  s.summary      = "A modern objective-c wrapper for the Google Places Autocomplete API"
  s.homepage     = "https://github.com/hkellaway/HNKGooglePlacesAutocomplete"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Harlan Kellaway" => "hello@harlankellaway.com" }
  s.source       = { :git => "https://github.com/hkellaway/HNKGooglePlacesAutocomplete.git", :tag => s.version.to_s }
  
  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source_files  = 'Pod/Classes/HNKGooglePlacesAutocomplete.{h,m}'

  s.subspec 'Models' do |ss|
    ss.source_files = 'Pod/Classes/HNKGooglePlacesAutocompleteModel.{h,m}', 'Pod/Classes/HNKQueryResponse.{h,m}', 'Pod/Classes/HNKQueryResponsePrediction.{h,m}', 'Pod/Classes/HNKQueryResponsePredictionMatchedSubstring.{h,m}', 'Pod/Classes/HNKQueryResponsePredictionTerm.{h,m}'
  end

  s.dependency "HNKServerFacade", "~> 0.2"
  s.dependency "Mantle", "~> 1.5"

end
