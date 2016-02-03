#
# Be sure to run `pod lib lint VRMaskColoredButton.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "VRMaskColoredButton"
  s.version          = "1.0.0"
  s.summary          = "iOS button control that assembles its images from masks and colors."

  s.description      = <<-DESC
                       This is a UIButton class descendant that allows you to set the shape and the color of the button's images independently. Works better with flat designs.
                       DESC

  s.homepage         = "https://github.com/IvanRublev/VRMaskColoredButton"
  s.license          = 'MIT'
  s.author           = { "Ivan Rublev" => "ivan@ivanrublev.me" }
  s.source           = { :git => "https://github.com/IvanRublev/VRMaskColoredButton.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'UIKit', 'CoreGraphics'
end
