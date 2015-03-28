#
# Be sure to run `pod lib lint resizable-navigation-bar.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "resizable-navigation-bar"
  s.version          = "0.1.0"
  s.summary          = "Resizable UINavigationBar for iOS8"
  s.description      = <<-DESC
                       With the use of a LVResizableNavigationController, view controllers can now set the height of the navigation bar dynamically.

                       To use, create a LVResizableNavigationController instead of UINavigationController, which will handle presentation and animations between UIViewControllers with different screen sizes.
                       DESC
  s.homepage         = "https://github.com/levelmoney/resizable-navigation-bar"
  s.license          = 'Eclipse 1.0'
  s.author           = { "Todd Anderson" => "todd@levelmoney.com" }
  s.source           = { :git => "https://github.com/levelmoney/resizable-navigation-bar.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/levelmoney'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'ResizableNavigationBar/Classes/*'
  s.frameworks = 'UIKit'
end
