Pod::Spec.new do |s|
  s.name = "PennyPincher"
  s.version = "0.0.1"
  s.summary = "PennyPincher is a fast template-based gesture recognizer, developed by Eugene Taranta and Joseph LaViola"
  s.homepage = "https://github.com/wilthink/PennyPincher"
  s.license = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.authors = "fe9lix", "Jason Jobe"
  s.ios.deployment_target = "8.0"
 # s.tvos.deployment_target = "9.0"
#  s.osx.deployment_target = "10.11"
  s.source = { :git => "https://github.com/wildthink/PennyPincher.git", :tag => "v#{s.version}" }
  s.default_subspec = "Core"
 
  s.subspec "Core" do |ss|
    ss.source_files  = "PennyPincher/**/*.swift"
  end

end
