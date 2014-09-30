Pod::Spec.new do |s|
  s.name         =  'Mixpanel-OSX-Community'
  s.version      =  '2.1.0'
  s.license      =  'Apache License'
  s.summary      =  'OS X tracking library for Mixpanel Analytics.'
  s.homepage     =  'http://mixpanel.com'
  s.author       =  { 'Mixpanel' => 'support@mixpanel.com', "orta" => "orta.therox@gmail.com", "codynhat" => "cody@hatfieldworks.com" }
  s.source       =  { :git => 'https://github.com/orta/mixpanel-osx-unofficial.git', :tag => '2.1.0' }
  s.frameworks = 'Cocoa', 'Foundation', 'SystemConfiguration'
  s.platform     =  :osx
  s.source_files =  'Mixpanel/**/*.{h,m}'
  s.requires_arc = true
end
