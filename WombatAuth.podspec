Pod::Spec.new do |s|
  s.name     = "WombatAuth"
  s.version  = "3.0.0"
  s.platform = :ios, "13"
  s.swift_version = "5"

  s.summary  = "Wombat iOS SDK"
  s.author   = { "Marsel Tzatzos" => "marsel.tzatzos@spielworks.com" }
  s.homepage = "https://getwombat.io"
  s.license  = { :type => "MIT", :file => "LICENSE" }

  s.source   = { :git => 'https://github.com/wombat-tech/wombat-sdk-ios.git', :tag => 'v#{s.version.to_s}' }
  s.ios.vendored_frameworks = 'Frameworks/WombatAuth.xcframework'
  s.frameworks = 'Foundation', 'AVFoundation'
end
