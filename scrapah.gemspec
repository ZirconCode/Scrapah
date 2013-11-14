# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "scrapah/version"

Gem::Specification.new do |s|
  s.name        = "Scrapah"
  s.version     = Mygem::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Gruening"]
  s.email       = ["simon@zirconcode.com"]
  s.homepage    = "https://github.com/ZirconCode/Scrapah"
  s.summary     = %q{TODO}
  s.description = %q{ToDo ....}

  # TODO
  #s.add_runtime_dependency "launchy"
  #s.add_development_dependency "rspec", "~>2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
