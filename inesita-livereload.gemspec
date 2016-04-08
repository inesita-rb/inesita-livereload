Gem::Specification.new do |s|
  s.name        = 'inesita-livereload'
  s.version     = '0.1.0'
  s.authors     = ['Michał Kalbarczyk']
  s.email       = 'fazibear@gmail.com'
  s.homepage    = 'http://github.com/inesita-rb/inesita-livereload'
  s.summary     = 'Livereload module for Inesita'
  s.description = s.summary
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ['lib']

  s.add_dependency 'opal', '~> 0.9'
  #s.add_dependency 'inesita', '~> 0.4.0'
  s.add_dependency 'listen', '~> 3.0'
  s.add_dependency 'websocket', '~> 1.0'
end
