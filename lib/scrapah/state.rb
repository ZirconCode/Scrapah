
module Scrapah

	class State

		# Store State of Scraper
		# ex. options, page number, tasks, etc...
		# Should be able to save/load

		# ! State should be retrievable by all those other things

		def initialize()
			@options = Hash.new


			@options[:gateway]
			@options[:gateway_state]
			@options[:storage]
			@options[:storage_state]
			# etc...?
		end


		# TODO obviously
		def set(key,value)

		end

		def get(key)

		end

		def save
			# everything should be json serializable...
			# storage/cache/files/results, stored hashes of them? hmm...
		end

		def load
			# ...everything should be json serializable
			# load @options
			@options[:gateway] = Scrapah::Gateway.create('openuri') if !opts[:gateway]
		end


	end


end

