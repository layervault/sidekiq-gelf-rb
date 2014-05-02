# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sidekiq-gelf"
  s.version = "0.0.2"

  s.author = "Ryan LeFevre"
  s.date = "2014-04-21"
  s.description = "GELF logging for Sidekiq"
  s.email = "ryan@layervault.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = `git ls-files`.split($/)
  s.homepage = "http://github.com/layervault/sidekiq-gelf-rb"
  s.require_paths = ["lib"]
  s.summary = "Format Sidekiq log messages for a GELF-supported logging server like Graylog2"
  s.license = 'MIT'

  s.add_dependency "gelf", '>= 1.4'
  s.add_dependency "sidekiq", '~> 3'

  s.add_development_dependency 'rake'
end

