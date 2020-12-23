Pod::Spec.new do |s|
  s.name             = 'SelfTableViewManager'
  s.version          = '5.1.1'
  s.summary          = 'Um jeito simples de criar e manipular uma TableView.'

  s.description      = <<-DESC
Esqueça todos os metodos obrigatórios para criar e manipular uma TableView, carregue modelos diferentes de UITableViewCell sem a necessidade de if no seu código.
                       DESC

  s.homepage         = 'https://github.com/jjfernandes87/SelfTableViewManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jjfernandes87' => 'julio.fernandes87@gmail.com' }
  s.source           = { :git => 'https://github.com/jjfernandes87/SelfTableViewManager.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'
  s.requires_arc = true

  s.cocoapods_version = '>= 1.5'
  s.swift_version = '5.0'

  s.source_files = 'SelfTableViewManager/Classes/**/*'

end
