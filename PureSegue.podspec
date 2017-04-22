Pod::Spec.new do |spec|
  spec.name             = 'PureSegue'
  spec.version          = '0.0.2'
  spec.summary          = 'Perform segue with configuration block'
  spec.homepage         = 'https://github.com/ajjnix/PureSegue'
  spec.license          = 'MIT'
  spec.authors      = {
     'Artem Mylnikov (ajjnix)' => 'ajjnix@gmail.com',
  }
  spec.source           = { :git => 'https://github.com/ajjnix/PureSegue.git', :tag => spec.version }

  spec.source_files = 'PureSegue/**/*.{swift,h}'
  spec.ios.deployment_target = '8.0'
  spec.requires_arc = true
end