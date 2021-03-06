#
# Be sure to run `pod lib lint FlexUI.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FlexUI'
  s.version          = '0.1.0'
  s.summary          = 'A short description of FlexUI.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/chmlaiii@gmail.com/FlexUI'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chmlaiii@gmail.com' => 'chmlaiii@gmail.com' }
  s.source           = { :git => 'https://github.com/chml/FlexUI.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5']

  s.source_files = [
    'FlexUI/Sources/**/*'
  ]
  s.dependency 'Yoga'
  s.dependency 'Runtime'
  s.dependency 'MPITextKit'
  s.dependency 'DifferenceKit'
  s.dependency 'Nuke'
  s.dependency 'Nuke-WebP-Plugin'
  s.dependency 'FLAnimatedImage'
  s.frameworks = 'UIKit'
end
