module Scrapah

	class CurlGateway < Gateway

		def initialize
			# TODO switch to open4
			# TODO take arguments & pipe into curl
			@cmd = 'curl "{{url}}"'
		end

		def get(url)
			use = @cmd.gsub('{{url}}',url)
			`#{use}`
		end

	end

end