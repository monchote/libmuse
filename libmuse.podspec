#
# Be sure to run `pod lib lint libmuse.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "libmuse"
  s.version          = "1.2.1"
  s.summary          = "libmuse is a library for interfacing with Muse headbands."

  s.description      = "libmuse is a library for interfacing with Muse headbands, including finding paired Muses, connecting to them, reading their state, and receiving packets for raw EEG data and all other values. You can use it in your own applications, subject to the terms of our license. The library consists of two parts: a core in C++ and a platform-specific interface in Objective-C for iOS."

  s.homepage         = "http://developer.choosemuse.com"
  s.license          = { :file => 'LICENSE', :type => 'Copyright' }
  s.author           = "InteraXon"
  s.social_media_url = "https://twitter.com/InteraXon"

  s.source           = { :git => "https://github.com/monchote/libmuse.git", :tag => s.version.to_s }
  s.documentation_url = "http://developer.choosemuse.com/ios/ios-api-reference#/"

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.ios.source_files = 'Headers/Muse/*.h'
  s.ios.vendored_libraries = 'libMuse.a'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-lc++' }
end
