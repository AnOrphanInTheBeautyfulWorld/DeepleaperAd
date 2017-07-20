Pod::Spec.new do |spec|
spec.name         = "DeepleaperAd"
spec.version      = "1.1.3"
spec.summary      = "Advertising platform!"
spec.homepage     = "https://github.com/AnOrphanInTheBeautyfulWorld/DeepleaperAd"
spec.license = { :type => 'MIT', :file => 'MIT-LICENSE.txt' }
spec.author             = { "ChangLiu" => "12000290@qq.com" }
spec.platform     = :ios, "8.0"
spec.source       = { :git => "https://github.com/AnOrphanInTheBeautyfulWorld/DeepleaperAd.git", :tag => '1.1.3' }
spec.resources = "DeepleaperAd.bundle"
spec.vendored_frameworks = "DeepleaperAd.framework"
spec.frameworks = 'AdSupport','StoreKit','Foundation','AVFoundation','UIKit'
end
