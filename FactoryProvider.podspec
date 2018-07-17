Pod::Spec.new do |s|
  s.name             = "FactoryProvider"
  s.version          = "0.2.1"
  s.summary          = "FactoryProvider - generate boilerplate of factory Swift framework."
  s.description      = <<-DESC
                        FactoryProvider is a framework to generate boilerplate of factory with an easy to write TestCase.
                        It generates factories automatically to enable this functionality.
                       DESC

  s.homepage         = "https://github.com/Nonchalant/FactoryProvider"
  s.license          = 'MIT'
  s.author           = { "Takeshi Ihara" => "afrontier829@gmail.com" }
  s.source           = {
      :git => "https://github.com/Nonchalant/FactoryProvider.git",
      :tag => s.version.to_s
  }

  s.ios.deployment_target       = '8.0'
  s.osx.deployment_target       = '10.9'
  s.watchos.deployment_target   = '2.0'
  s.tvos.deployment_target      = '9.0'
  s.source_files                = ['Source/**/*.swift']
  generator_name                = 'generate'
  s.preserve_paths              = ['Generator/**/*', generator_name]
  s.prepare_command             = <<-CMD
                                    curl -Lo #{generator_name} https://github.com/Nonchalant/FactoryProvider/releases/download/#{s.version}/#{generator_name}
                                    chmod +x #{generator_name}
                                CMD
  s.frameworks                  = 'Foundation'
  s.requires_arc                = true
  s.pod_target_xcconfig         = { 'ENABLE_BITCODE' => 'NO', 'SWIFT_REFLECTION_METADATA_LEVEL' => 'none' }
end