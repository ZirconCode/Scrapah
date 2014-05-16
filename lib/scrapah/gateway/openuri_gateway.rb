require 'open-uri'

module Scrapah

	class OpenuriGateway < Gateway

		# TODO arguments & meta-data (agents...)

		def get(url)
			open(url)
		end

	end

end