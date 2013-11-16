# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "scrapah/version"

Gem::Specification.new do |s|

  s.name        = "Scrapah"
  s.version     = Scrapah::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Simon Gruening"]
  s.email       = ["simon@zirconcode.com"]
  s.license     = 'MIT'
  s.homepage    = "https://github.com/ZirconCode/Scrapah"
  s.summary     = %q{Flexible Web Scraping and Content Extraction}
  s.description = %q{A flexible web-scraper with built in content extraction}

  
  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency 'nokogiri', '>= 1.6.0'
  s.add_runtime_dependency 'retryable', '>= 1.3.3'
  s.add_runtime_dependency 'json', '>= 1.8.1'

  s.add_runtime_dependency 'watir-webdriver', '>= 0.6.4'
  s.add_runtime_dependency 'headless', '>= 1.0.1' # needs xvfb installed

  #s.add_development_dependency "rspec", "~>2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
end
