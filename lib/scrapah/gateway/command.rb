


# !TODO!

module Scrapah

	class Gateway_Command < Gateway

		def initialize
			@cmd = 'curl "{{url}}"'
		end


		def get(url)
			use = @cmd.gsub('{{url}}',url)
			`#{use}`
		end

	end

end
