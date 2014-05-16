

# Test scraper.rb

require 'test/unit'
require '../lib/scrapah/scraper'
require '../lib/scrapah/helpers/extract' # for test_process

# !TODO
#require '../lib/scrapah'
require '../lib/scrapah/gateway/gateway'
require '../lib/scrapah/gateway/openuri_gateway'
require '../lib/scrapah/gateway/webdriver_gateway'
require '../lib/scrapah/gateway/curl_gateway'


class TestScraper < Test::Unit::TestCase

	def setup
		# Uses fixtures/profile.html as "web access"
		@fixture_profile = Dir.pwd+"/fixtures/profile.html"
	end


	def test_new_openuri
		s = nil

		assert_nothing_raised do
			s = Scrapah::Scraper.new :gateway => Scrapah::Gateway.create('openuri')
		end
		assert(s.is_a? Scrapah::Scraper)
	end

	def test_get_openuri
		s = Scrapah::Scraper.new #:gateway => Scrapah::Gateway.create('openuri')
		f = @fixture_profile

		assert(s.get(f).to_s.include? 'Sed ut perspiciatis unde omnis')
	end

	def test_new_headless
		s = nil

		assert_nothing_raised do
			s = Scrapah::Scraper.new :gateway => Scrapah::Gateway.create('webdriver')
		end
		assert(s.is_a? Scrapah::Scraper)
	end

	# heavy test
	def test_start_stop_headless
		s = Scrapah::Scraper.new :gateway => Scrapah::Gateway.create('webdriver')

		assert_nothing_raised do
			s.start
			s.stop
		end
	end

	# heavy test
	def test_get_headless
		s = Scrapah::Scraper.new :gateway => Scrapah::Gateway.create('webdriver')
		f = 'file://'+@fixture_profile

		s.start
		
		assert(s.get(f).to_s.include? 'Sed ut perspiciatis unde omnis')

		s.stop
	end

	# Full Use Test
	def test_process
		s = Scrapah::Scraper.new :gateway => Scrapah::Gateway.create('openuri')
		f = @fixture_profile

		s.visit(f)

		assert(s.process(/Sed ut perspiciatis/).count == 1)

		h = Hash.new
		h[:regex] = /Sed ut perspiciatis/
		h[:proc]  = Proc.new{|d| Scrapah::Extract.emails(d)}
		h[:css]   = "c|span"
		h[:xpath] = "x|/html/body/div/div"

		result = s.process(h)

		assert(result[:regex].count == 1)
		assert(result[:proc].count == 1)
		assert(result[:css].count == 2)
		assert(result[:xpath].include? 'Johnny Blah')
	end


end

