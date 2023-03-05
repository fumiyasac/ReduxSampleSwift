# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'ReduxSampleSwift' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ReduxSampleSwift

  # メイン機能用のライブラリ
  pod 'ReSwift'
  pod 'Alamofire'
  pod 'PromiseKit'

  # そのほか便利ライブラリ
  pod 'AlamofireImage'
  pod 'RealmSwift'
  pod 'SwiftyJSON'

  # UI構築用ライブラリ
  pod 'CalculateCalendarLogic'
  pod 'KYNavigationProgress'

  target 'ReduxSampleSwiftTests' do
    # inherit! :search_paths
    # Pods for testing

    # For Test
    pod 'ReSwift'
    pod 'Alamofire'
  end

#  target 'ReduxSampleSwiftUITests' do
#    inherit! :search_paths
#    # Pods for testing
#  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if ['KYNavigationProgress'].include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.2'
      end
    end
  end
end
