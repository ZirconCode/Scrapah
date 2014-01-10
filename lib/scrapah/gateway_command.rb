


# !TODO!

module Scrapah

	class Gateway_Command < Gateway

		def start()
			@cmd = '`curl "{{url}}"`'
		end

		def get(url)
			use = @cmd.gsub('{{url}}',url)
			x%{ use }
		end

	end

end