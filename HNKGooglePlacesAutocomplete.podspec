Pod::Spec.new do |s|
  s.name         = "HNKGooglePlacesAutocomplete"
  s.version      = "0.1.0"
  s.summary      = "A modern objective-c wrapper for the Google Places Autocomplete API"
  s.homepage     = "https://github.com/hkellaway/HNKGooglePlacesAutocomplete"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Harlan Kellaway" => "hello@harlankellaway.com" }
  s.source       = { :git => "https://github.com/hkellaway/HNKGooglePlacesAutocomplete.git", :tag => s.version.to_s }
  
  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.source_files  = 'Pod/Classes'

end
