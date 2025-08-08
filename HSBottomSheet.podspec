#
# Be sure to run `pod lib lint HSBottomSheet.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HSBottomSheet'
  s.version          = '0.2.0'
  s.summary          = 'A flexible iOS library for presenting view controllers as bottom sheets and side menus with customizable positioning, sizing, and animations.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
HSBottomSheet is a flexible iOS library that allows you to present view controllers as bottom sheets and side menus with extensive customization options.

Features:
- Bottom Sheet: Present view controllers as bottom sheets with customizable edges and corner radius
- Side Menu: Present view controllers as side menus with multiple positioning options
- Flexible Positioning: Support for left/right positioning and top/center/bottom/full-height alignment
- Customizable Sizing: Control the width percentage of side menus (10% to 100% of screen width)
- Gesture Support: Swipe to dismiss functionality with configurable thresholds
- Safe Area Support: Proper handling of safe areas for all device orientations
- Customizable UI: Configurable corner radius, dismiss buttons, and callbacks
                       DESC

  s.homepage         = 'https://github.com/Himanshu/HSBottomSheet'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Himanshu' => 'himanshusingh@hotmail.co.uk' }
  s.source           = { :git => 'https://github.com/Himanshu/HSBottomSheet.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.source_files = 'HSBottomSheet/Classes/**/*'
  
  s.resource_bundles = {
    'HSBottomSheet' => ['HSBottomSheet/Classes/*.storyboard']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
