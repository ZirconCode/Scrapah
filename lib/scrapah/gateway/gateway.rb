module Scrapah

	# Gateway to Internet

	class Gateway

		def self.create(name)
			case name
			when :openuri
				return Gateway_Openuri.new
			when :webdriver
				return Gateway_Webdriver.new
			when :command
				return Gateway_Command.new	
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