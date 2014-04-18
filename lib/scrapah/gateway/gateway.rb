

module Scrapah

	# Gateway to Internet

	class Gateway

		def self.create(name)
			case name
			when "openuri"
				return Gateway_Openuri.new
			when "webdriver"
				return Gateway_Webdriver.new
			when "command" 
				return Gateway_Command.new	
			end
		end

		def initialize
			#start
		end

		def start
			true
		end

		def stop
			true
		end

		def get(url)
			""
		end

	end

end

