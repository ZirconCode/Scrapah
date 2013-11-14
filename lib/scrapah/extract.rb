
module Scrapah

	# TODO module? mm
	module Extract


		# Not Perfect, but Good
		# TODO, make case insensitive and remove one set?
		def self.emails(content)

			# deals with nokogiri and misc
			content = content.to_s if content.respond_to?(:to_s) && !content.is_a?(String)

			r = Regexp.new(/\b([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4})\b/)
		
			emails = []
			emails << content.scan(r)
			emails.uniq!.flatten!

			emails

		end


	end

end