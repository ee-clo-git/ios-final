# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'TPP' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TPP
  pod 'SnapKit'
  pod 'RxCocoa'
  pod 'Device'
  pod 'RESideMenu'
  pod 'Kingfisher'
  pod 'KeychainAccess'
  pod 'Mapbox-iOS-SDK'
  pod 'XLPagerTabStrip'
  pod 'Moya-ObjectMapper/RxSwift'
  pod 'Moya'
  pod 'RxSwift'
  pod 'UrbanAirship-iOS-SDK'
  pod 'ImagePicker', :git=> 'https://github.com/love4soul/ImagePicker', :branch => 'feature/video_support'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'STPopup'
  pod 'UITextView+Placeholder'
  pod 'UICircularProgressRing'
  pod 'GrowingTextViewHandler-Swift', '1.1'
  pod 'DZNEmptyDataSet'
  pod 'MBProgressHUD'
  pod 'Eureka', '2.0.0-beta.1'
  pod 'DZNWebViewController'
  
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'
  pod 'FBSDKShareKit'

  pod 'TwitterKit'
end

target 'TPPNotification' do
    use_frameworks!
    pod 'UrbanAirship-iOS-AppExtensions'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
