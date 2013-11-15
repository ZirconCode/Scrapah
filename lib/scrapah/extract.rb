
module Scrapah

	class Extract

		# These methods are Not Perfect, but Good enough
		# They are designed to extract from plain text
		# Non-obfuscated plain text...
		# Please don't spam me =(

		# TODO, make case insensitive and remove one set?
		def self.emails(content)
			r = Regexp.new(/\b([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4})\b/)
			regex(content,r)
		end

		def self.ips(content)
			# very simple IPv4 regex
			r = Regexp.new(/\b((?:[0-9]{1,3}\.){3}[0-9]{1,3})\b/)
			regex(content,r)
		end

		def self.proxies(content)
			# ex. IPadress:port
			r = Regexp.new(/\b((?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\:[0-9]{1,5})\b/)
			regex(content,r)
		end

		def self.regex(content, regex)
			# deals with nokogiri and misc
			if content.respond_to?(:to_s) && !content.is_a?(String)
				content = content.to_s 
			end

			results = []
			results << content.scan(regex)
			results = results.flatten.uniq

			results
		end


	end

end
