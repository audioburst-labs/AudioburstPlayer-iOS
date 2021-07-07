Pod::Spec.new do |s|
  s.name             = 'AudioburstPlayer'
  s.version          = '0.3.3'
  s.summary          = 'Official player from Audioburst'

  s.homepage         = 'https://github.com/audioburst-labs/AudioburstPlayer-iOS'
  s.license          = { :type => 'Custom'}
  s.author           = { 'Audioburst' => 'alex.kobylak@audioburst.com' }
  s.source           = { :git => 'https://github.com/audioburst-labs/AudioburstPlayer-iOS.git', :tag => s.version.to_s }

  s.platform = :ios
  s.ios.deployment_target = '12.0'
  s.vendored_frameworks = "AudioburstPlayer.xcframework"
  s.swift_version = "5.0"
  s.source_files = 'AudioburstPlayer.xcframework/*/AudioburstPlayer.framework/Headers/*.{h,m,swift}'

  s.dependency 'Alamofire', '~> 5.0.0-rc.2'
  s.dependency 'SwiftGen', '~> 6.0'
  s.dependency 'IBPCollectionViewCompositionalLayout', '~> 0.6.7'
  s.dependency 'Cache', '~> 5.2.0'
  s.dependency 'lottie-ios', '~> 3.1.5'
  s.dependency 'SDWebImage', '5.4.0'
  s.dependency 'OwlKit', '1.1.1'
end
