platform :ios, '13.0'
#use_frameworks!
inhibit_all_warnings!

target 'AuthTask' do
  use_frameworks!

  #Networking
  pod 'Moya/RxSwift'
  pod 'Moya-ObjectMapper/RxSwift'
  pod 'ARSLineProgress'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'GoogleSignIn'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SKCountryPicker'
  pod 'SwiftValidators'
  pod 'IQKeyboardManagerSwift'

end


#post_install do |installer|
#    installer.pods_project.build_configurations.each do |config|
#        config.build_settings.delete('CODE_SIGNING_ALLOWED')
#        config.build_settings.delete('CODE_SIGNING_REQUIRED')
#    end
#    
#    installer.pods_project.targets.each do |target|
#        target.build_configurations.each do |config|
#            config.build_settings['BITCODE_GENERATION_MODE'] = 'bitcode'
#            config.build_settings['ENABLE_BITCODE'] = 'YES'
#        end
#    end
#end

post_install do |pi|
      pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          config.build_settings['SWIFT_VERSION'] = '5.0'
        end
      end
  end
