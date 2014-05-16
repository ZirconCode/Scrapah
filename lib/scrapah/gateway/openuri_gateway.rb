require 'open-uri'

module Scrapah

	class OpenuriGateway < Gateway

		# TODO arguments & meta-data (agents...)
		# proxies, timeouts...

		def get(url)
			f = open(url).read
		end

	end

end