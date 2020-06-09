Pod::Spec.new do |s|
  s.name     = "WombatAuth"
  s.version  = "2.0.0"
  s.platform = :ios, "9"
  s.swift_version = "5"

  s.summary  = "Wombat iOS SDK"
  s.author   = { "Matej Dorcak" => "sss.mado@gmail.com" }
  s.homepage = "https://getwombat.io"
  s.license  = { :type => "MIT", :file => "LICENSE" }

  s.source   = { :http => "https://github.com/wombat-tech/wombat-sdk-ios/releases/download/v#{s.version}/WombatAuth.zip" }
  s.ios.vendored_frameworks = "WombatAuth.framework"
  s.frameworks =  "Foundation", "AVFoundation"
end
