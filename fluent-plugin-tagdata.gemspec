# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-tagdata"
  spec.version       = "0.0.1"
  spec.authors       = ["Fukui Masayuki"]
  spec.email         = ["msfukui@gmail.com"]
  spec.description   = %q{Fluentd plugin to put the tag records in the data.}
  spec.summary       = %q{Fluentd plugin to put the tag records in the data.}
  spec.homepage      = "https://github.com/msfukui/fluent-plugin-tagdata"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'fluentd'
  spec.add_runtime_dependency     'fluentd'
end
