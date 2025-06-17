Pod::Spec.new do |s|
  s.name             = 'CastarSDK'
  s.version          = '1.0.0'
  s.summary          = 'CastarSDK for iOS'
  s.description      = 'CastarSDK for iOS applications'
  s.homepage         = 'https://example.com'
  s.license          = { :type => 'Commercial', :text => 'Proprietary' }
  s.author           = { 'CastarSDK' => 'info@example.com' }
  s.source           = { :path => '.' }
  s.ios.deployment_target = '12.0'
  s.ios.vendored_frameworks = 'CastarSDK.framework'
  s.swift_version = '5.0'
end 