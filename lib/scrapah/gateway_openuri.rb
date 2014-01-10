

require 'open-uri'


module Scrapah

	class Gateway_Openuri < Gateway

		def get(url)
			open(url)
		end

	end

end