

# Test cache.rb

require 'test/unit'
require_relative '../lib/scrapah/cache.rb'


class TestCache < Test::Unit::TestCase

	def setup
		@c = Cache.new
	end


	def test_new()
		
		assert(@c.instance_of? Cache)	
	end

	def test_store_and_get
		@c.store("test",3)
		assert(@c.get("test") == 3)

		assert(@c.get("doesn't exist").nil?)
	end

	def test_has_key()
		@c.store("test",3)
		assert(@c.has_key? "test")
		assert(!@c.has_key?("nope"))
	end

	def test_clear()
		@c.store("test",3)

		assert(@c.get("test")==3)
		@c.clear
		assert(@c.get("test").nil?)
	end

	def test_save_and_load()
		@c.store("old",1)
		@c.save
		@c.clear
		@c.load
		assert(@c.get("old")==1)
		# TODO fix requires and figure out the correct way to do them
	end

end



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



