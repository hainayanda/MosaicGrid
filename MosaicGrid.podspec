#
# Be sure to run `pod lib lint MosaicGrid.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MosaicGrid'
  s.version          = '1.2.0'
  s.summary          = 'MosaicGrid is a SwiftUI library that provides both horizontal and vertical mosaic grid views.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  MosaicGrid is a SwiftUI library that provides both horizontal and vertical mosaic grid views, along with utility functions for customizing view tile sizes and placement. These components allow you to arrange multiple items in a visually appealing grid layout.
                       DESC

  s.homepage         = 'https://github.com/hainayanda/MosaicGrid'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hainayanda' => 'hainayanda@outlook.com' }
  s.source           = { :git => 'https://github.com/hainayanda/MosaicGrid.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = "16.0"
  s.osx.deployment_target = "13.0"
  s.tvos.deployment_target = '16.0'
  s.watchos.deployment_target = '9.0'
  s.swift_versions = '5.5'

  s.source_files = 'MosaicGrid/Classes/**/*'
  
  # s.resource_bundles = {
  #   'MosaicGrid' => ['MosaicGrid/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
