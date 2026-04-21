#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint corner_adaptive_safe_area.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'corner_adaptive_safe_area'
  s.version          = '0.0.1'
  s.summary          = 'Bridges iOS 26 corner adaptation margins to Flutter.'
  s.description      = <<-DESC
Exposes UIView corner-adaptation layout region insets (iOS 26+) to Flutter so
widgets can avoid floating-window controls and rounded display corners.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.10'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'corner_adaptive_safe_area_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
