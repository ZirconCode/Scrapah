

require 'open-uri'


module Scrapah

	class OpenuriGateway < Gateway

		def get(url)
			open(url)
		end

	end

end