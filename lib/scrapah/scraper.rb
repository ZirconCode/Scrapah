
class Scraper

	# TODO needs full url for caching to work atm

	def initialize(scrape_type=:openuri, caching=false)
		@access_type = scrape_type
		@current_url = ''

		@caching = caching
		if cache
			@cache = Cache.new
			@cache.load
		end

		# .start automatically if needed?
	end
	

	def start()
		# start headless
		if(@access_type == :headless)
			@headless = Headless.new
			@headless.start
			@browser = Watir::Browser.new #default browser
		end
	end
	
	def stop()
		# end headless/close stuff
		if(@access_type == :headless)
			@browser.close
			@headless.destroy
		end
	end
	

	def visit(url)
		# cache the url

		@current_url = url

		return nil if !@caching
		
		doc = get_appropriate(url)

		@cache.store(url,doc.to_s)
		@cache.save #TODO ???
	end
	
	def get(url)
		# visit(url) if caching and not cached
		# return result
		@current_url = url

		if(@caching)
			go(url) if !@cache.has_key? url
			Nokogiri::HTML(@cache.get(url))
		else
			get_appropriate(url)
		end
	end

	# TODO split process! and process ....
	def process(input)
		# get current_url source
		doc = get(@current_url)
		
		if input.is_a?(Hash)
			input.each{|k,v| input[k] = process_appropriate(doc,v)}
		else
			input = process_appropriate(doc,input)
		end

		input
	end


	private

		# returns nokogiri doc's
		def get_appropriate(url)
			return get_headless(url) if(@access_type == :headless)
			return get_openuri(url)  if(@access_type == :openuri)
		end

		def get_headless(url)
			return nil if !started_headless?
			
			@browser.goto url
			Nokogiri::HTML(@browser.html)
		end

		def get_openuri(url)
			Nokogiri::HTML(open(url))
		end


		def started_headless?()
			if @browser.nil? || @headless.nil? 
				raise 'Call Scraper.start first when using :headless' 
			end
		end


		# accepts nokogiri doc's only atm
		def process_appropriate(doc,cmd)
			
			return process_regex(doc,cmd) if(cmd.is_a? Regexp)
			return process_proc(doc,cmd) if(cmd.is_a? Proc)

			if cmd.is_a?(String)
				return process_xpath(doc,cmd) if cmd.start_with?("x|")
				return process_css(doc,css) if cmd.start_with?("c|")
			end
			
			nil

		end

		def process_regex(doc,regex)
			doc.to_s.scan(regex).flatten
		end

		def process_xpath(doc,xpath)
			xpath.delete!('x|')
			sanitize_nokogiri doc.xpath(xpath)
		end

		def process_css(doc,css)
			css.delete!('c|')
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
