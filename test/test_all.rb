
require 'test/unit'

require_relative 'test_cache.rb'
require_relative 'test_extract.rb'


# TODO Refactor... haha
def temporary_test
	s = Scraper.new :openuri
	s.start

	s.get('https://news.ycombinator.com/item?id=6709901') #random...

	results = Hash.new
	results[:name] = 'regex, or ruby code here.... hmm'
	results[:bleh] = /(...research...)/
	results[:code] = Proc.new{|d| d.css('a').count}
	results[:test] = Proc.new{|d| d.xpath("//span[@class='pagetop']/b").to_s}
	results[:tes2] = /\"user\?id=(.*?)\"/
	results[:tes3] = /noexisttest/
	results[:tes4] = "x|//span[@class='pagetop']/b"
	results[:tes5] = "x|//span[@class='pagetop']/a"
	results[:tes6] = "c|form"

	p s.process(results)

	s.stop

	puts 'finished'
end



