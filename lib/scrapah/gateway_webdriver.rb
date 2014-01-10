

require 'watir-webdriver'
require 'headless' # needs xvfb installed


module Scrapah

	class Gateway_Webdriver < Gateway


		def start
			@invisible = false

			if(@invisible)
			 	@headless = Headless.new
				@headless.start
			end

			@browser = Watir::Browser.new #default browser
		end

		def stop
			@browser.close

			if(@invisible) 
				@headless.destroy
			end
		end

		def get(url)
			return nil if !started_headless?

			@browser.goto url
			@browser.html
		end

		private

			def started_headless?()
					if @browser.nil? || (@headless.nil? && @invisible)
						raise 'Call Scraper.start first when using :headless' 
						return false
					end
					return true
			end

	end

end