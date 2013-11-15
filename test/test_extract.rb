

# Test extract.rb

require 'test/unit'
require '../lib/scrapah/extract'


class TestExtract < Test::Unit::TestCase

	def test_emails
		s = "test tes.com test@test.com tete@ .org"
		assert(Scrapah::Extract.emails(s).count == 1)
	end

	def test_ips
		s = "654.123 123.143.114.123 123.143.654.123 123.143.654.12322"
		assert(Scrapah::Extract.ips(s).count == 1)
	end

	def test_proxies
		s = "123.143. 654.123 112.143.114.123:4444 123.143.654.12322"
		assert(Scrapah::Extract.proxies(s).count == 1)
	end

	def test_regex
		s = 'hello hall o ello olle o.O/'
		assert(Scrapah::Extract.regex(s,/(.ll)/).count == 3)
	end
	

end


