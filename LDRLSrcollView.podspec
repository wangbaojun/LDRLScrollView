Pod::Spec.new do |s|
  s.name             = 'LDRLSrcollView'
  s.version          = '0.2.0'
  s.summary          = 'A short description of LDRLSrcollView.'

  s.description      = "ITxiansheng"

  s.homepage         = 'https://github.com/<GITHUB_USERNAME>/LDRLSrcollView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'bjwangbaojun' => 'itxiansheng@gmail.com' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/LDRLSrcollView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'LDRLSrcollView/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'

  s.resources = 'LDRLSrcollView/Assets/LDPullToReload.xcassets'

end
