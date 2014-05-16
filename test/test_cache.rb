

# Test cache.rb

require 'test/unit'
require '../lib/scrapah/cache/cache'


class TestCache < Test::Unit::TestCase

	def setup
		@c = Scrapah::Cache.new
	end


	def test_new()
		assert(@c.instance_of? Scrapah::Cache)	
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
	end

end


