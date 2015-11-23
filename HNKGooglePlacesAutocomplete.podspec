Pod::Spec.new do |s|
  s.name             = "HNKGooglePlacesAutocomplete"
  s.version          = "1.2.0"
  s.summary          = "An Objective-C wrapper for the Google Places Autocomplete API"
  s.description      = "An Objective-C wrapper for the GooglePlaces Autocomplete API. HNKGooglePlacesAutocomplete encapsulates the same core functionality as SPGooglePlacesAutocomplete - autocomplete suggestions and Google Place-to-CLPlacemark translation - with a more modern approach."
  s.homepage         = "https://github.com/hkellaway/HNKGooglePlacesAutocomplete"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Harlan Kellaway" => "hello@harlankellaway.com" }
  s.source           = { :git => "https://github.com/hkellaway/HNKGooglePlacesAutocomplete.git", :tag => s.version.to_s }
  
  s.platform         = :ios, "8.0"
  s.requires_arc     = true
  s.default_subspecs = 'Core', 'AFNetworking'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Pod/Classes/*'
    ss.dependency 'Mantle', '~> 2.0'
    ss.frameworks = 'CoreLocation'
    ss.platform = :ios, '8.0'
  end

  s.subspec 'AFNetworking' do |ss|
    ss.dependency 'HNKGooglePlacesAutocomplete/Core'
    ss.dependency 'HNKServerFacade', '~> 0.3'
    ss.prefix_header_contents = '#define HNK_AFNETWORKING 1'
    ss.platform = :ios, '8.0'
  end

end
