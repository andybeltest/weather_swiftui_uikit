workspace 'WeatherJp'
platform :ios, '15.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!


target 'WeatherJp' do
  pod 'Swinject', '~> 2.8.3'
  pod 'AsyncLocationKit', :git => 'https://github.com/AsyncSwift/AsyncLocationKit.git', :tag => '1.6.4'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
            config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
        end
    end
end
