Pod::Spec.new do |s|
  s.name             = 'CastarSDK'
  s.version          = '1.0.0' # Placeholder, adjust if you know the exact SDK version
  s.summary          = 'CastarSDK for iOS integration.'
  s.description      = <<-DESC
A local pod for integrating the pre-compiled CastarSDK.framework into a Flutter iOS project.
                       DESC
  s.homepage         = 'https://github.com/srujan5570/my-time'
  s.author           = { 'Auto-generated' => 'auto@generated.com' }
  s.source           = { :path => '.' } # Podspec is in the 'ios' directory
  s.ios.deployment_target = '12.0'
  s.vendored_frameworks = 'Frameworks/CastarSDK.framework' # Path relative to the podspec file
  s.swift_version = '5.0' # Assuming Swift 5, adjust if needed by CastarSDK
end 