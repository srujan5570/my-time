Pod::Spec.new do |s|
  s.name             = 'CastarSDK'
  s.version          = '1.0.0'
  s.summary          = 'CastarSDK for iOS'
  s.description      = <<-DESC
CastarSDK SDK for iOS helps you make money with iOS apps.
                       DESC
  s.homepage         = 'https://castar.com'
  s.license          = { :type => 'Commercial', :text => 'Copyright (c) 2024 Castar. All rights reserved.' }
  s.author           = { 'Castar' => 'support@castar.com' }
  s.source           = { :path => '.' }
  s.ios.deployment_target = '12.0'
  s.vendored_frameworks = 'Frameworks/CastarSDK.framework'
  s.frameworks = 'Foundation'
  s.swift_version = '5.0'
end 