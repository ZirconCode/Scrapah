require 'test/unit'
require '../lib/scrapah/gateway/gateway'
require '../lib/scrapah/gateway/openuri_gateway'
require '../lib/scrapah/gateway/webdriver_gateway'
require '../lib/scrapah/gateway/curl_gateway'

class TestGateway < Test::Unit::TestCase

	# TODO put tests in respective seperate files

	def setup
		# Uses fixtures/profile.html as "web access"
		@fixture_profile = Dir.pwd+"/fixtures/profile.html"
	end

	# gateway
	def test_gateway_create
		assert_raise RuntimeError do
			s = Scrapah::Gateway.create(:nonexistat)
		end
	end

	# openuri
	def test_openuri_create
		s = nil

		assert_nothing_raised do
			s = Scrapah::Gateway.create(:openuri)
		end

		assert(s.is_a? Scrapah::OpenuriGateway)
	end

	def test_openuri_get
		s = Scrapah::Gateway.create(:openuri)
		f = @fixture_profile

		assert(s.get(f).include? 'Sed ut perspiciatis unde omnis')
	end

	# webdriver
	def test_webdriver_create
		s = nil

		assert_nothing_raised do
			s = Scrapah::Gateway.create(:webdriver)
		end
		assert(s.is_a? Scrapah::WebdriverGateway)
	end

		# *heavy test
	def test_webdriver_start_stop
		s = Scrapah::Gateway.create(:webdriver)

		assert_nothing_raised do
			s.start
			s.stop
		end
	end

		# *heavy test
	def test_webdriver_get
		s = Scrapah::Gateway.create(:webdriver)
		f = 'file://'+@fixture_profile

		s.start
		assert(s.get(f).to_s.include? 'Sed ut perspiciatis unde omnis')
		s.stop
	end

	# curl
	def test_curl_get
		s = Scrapah::Gateway.create(:curl)
		f = 'file://'+@fixture_profile

		assert(s.get(f).to_s.include? 'Sed ut perspiciatis unde omnis')
	end

end