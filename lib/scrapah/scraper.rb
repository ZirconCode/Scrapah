

require 'nokogiri'

require 'retryable'



module Scrapah

	class Scraper

		include Retryable

		# TODO needs full url for caching to work properly atm
		# TODO Patterns class, for recursive-autodiscovery proxy-switching etc... ?


		def initialize(opts=Hash.new)
			opts[:gateway] = Scrapah::Gateway.create('openuri') if !opts[:gateway]
			set_gateway(opts[:gateway])

			@current_url = ''

			@caching = opts[:caching] || false
			if @caching
				@cache = Scrapah::Cache.new
				@cache.load
			end

			# .start automatically?
		end
		
		def set_gateway(gateway)
			raise "#{gateway} is not a gateway" if !gateway.is_a?(Scrapah::Gateway)

			@gateway = gateway
		end

		def start()
			@gateway.start
		end
		
		def stop()
			@gateway.stop
		end
		

		def visit(url)
			# cache the url

			@current_url = url

			return nil if !@caching
			
			doc = get_from_gateway(url)

			@cache.store(url,doc.to_s)
			@cache.save #TODO ???
		end
		
		def get(url)
			# visit(url) if caching and not cached
			# return result
			@current_url = url

			if(@caching)
				visit(url) if !@cache.has_key? url
				Nokogiri::HTML(@cache.get(url))
			else
				get_from_gateway(url)
			end
		end

		# TODO split process! and process ....
		def process(input)
			# get current_url source
			doc = get(@current_url)
			
			if input.is_a?(Hash)
				result = Hash.new
				input.each{|k,v| result[k] = process_appropriate(doc,v)}
				return result
			else
				return process_appropriate(doc,input)
			end

			nil
		end


		private

			# TODO retry & retry strategies
			def get_from_gateway(url)
				retryable :tries => 4, :sleep => 1.5 do
					Nokogiri::HTML(@gateway.get(url))
				end
			end


			# accepts nokogiri doc's only atm
			def process_appropriate(doc,cmd)
				
				return process_regex(doc,cmd) if(cmd.is_a? Regexp)
				return process_proc(doc,cmd) if(cmd.is_a? Proc)

				if cmd.is_a?(String)
					return process_xpath(doc,cmd) if cmd.start_with?("x|")
					return process_css(doc,cmd) if cmd.start_with?("c|")
				end
				
				nil

			end

			def process_regex(doc,regex)
				doc.to_s.scan(regex).flatten
			end

			def process_xpath(doc,xpath)
				xpath.slice!('x|')
				sanitize_nokogiri doc.xpath(xpath)
			end

			def process_css(doc,css)
				css.slice!('c|')
				sanitize_nokogiri doc.css(css)
			end

			def process_proc(doc,proc)
				proc.call(doc)
			end


			def sanitize_nokogiri(stuff)
				return stuff.to_s if(stuff.count == 1)

				result = []
				stuff.each{|a| result << a.to_s}
				result
			end
		

	end

end
