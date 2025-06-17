Pod::Spec.new do |s|
  s.name             = 'CastarSDK'
  s.version          = '1.0.0'
  s.summary          = 'CastarSDK for iOS'
  s.description      = 'CastarSDK SDK for iOS helps you make money with iOS apps.'
  s.homepage         = 'https://castar.com'
  s.license          = { :type => 'Commercial', :text => 'Copyright (c) 2024 Castar. All rights reserved.' }
  s.author           = { 'Castar' => 'support@castar.com' }
  s.source           = { :path => '.' }
  s.platform         = :ios, '12.0'
  s.preserve_paths   = 'CastarSDK.framework'
  s.vendored_frameworks = 'CastarSDK.framework'
  s.frameworks       = 'Foundation', 'UIKit'
  s.requires_arc     = true
  s.swift_version    = '5.0'
end 