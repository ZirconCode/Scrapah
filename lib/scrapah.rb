
# Scrapah

# / ZirconCode


# TODO Make requires run-time? 
# why require headless and stuff when not needed?

require 'nokogiri'
require 'open-uri'
require 'watir-webdriver'
require 'headless' # needs xvfb installed
require 'json' # yeah?


module Scrapah

	require_relative 'scrapah/cache.rb'
	require_relative 'scrapah/scraper.rb'
	require_relative 'scrapah/extract.rb'

end



