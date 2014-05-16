module Scrapah

	# Gateway to Internet

	class Gateway

		def self.create(name)
			case name
			when :openuri
				return OpenuriGateway.new
			when :webdriver
				return WebdriverGateway.new
			when :curl
				return CurlGateway.new
			else
				raise 'Gateway Type does not Exist: '+name.to_s	
			end
		end

		def initialize
			
		end

		# starts all ressources required by gateway
		def start
			true
		end

		# stops all ressources required by gateway
		def stop
			true
		end

		# returns raw web-content
		def get(url)
			""
		end

	end

end