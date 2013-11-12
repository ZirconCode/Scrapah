
class Scraper

	# TODO needs full url for caching to work atm

	def initialize(scrape_type=:headless)
		@access_type = scrape_type
		@cache = Cache.new
		@cache.load
		@current_url = ''
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
	
	
	def go(url)
		# visit and cache the url
		@current_url = url
		if(@access_type == :headless)
			@browser.goto url
			doc = Nokogiri::HTML(@browser.html)
		elsif (@access_type == :openuri)
			doc = Nokogiri::HTML(open(url))
		end
		@cache.store(url,doc.to_s)
		@cache.save
	end
	
	def get(url)
		# go(url) if not exists in cache
		# return result
		@current_url = url
		go(url) if !@cache.has_key? url
		Nokogiri::HTML(@cache.get(url))
	end
	
	
	def process(hash)
		# get current_url source
		doc = get(@current_url)
		# fill in hash
		# replace regex with results
		# replace code with results
		# accept css and xpath?
		# clean results & return them
		hash.each do |k,v| 

			if(v.is_a? Regexp)
				hash[k] = doc.to_s.scan(v).flatten
			end

			if(v.is_a?(String) && v.start_with?("x|"))
				v.delete!('x|')
				hash[k] = sanitize_nokogiri doc.xpath(v)
			elsif(v.is_a?(String) && v.start_with?("c|"))
				v.delete!('c|')
				hash[k] = sanitize_nokogiri doc.css(v)
			end
				
			# code...? how~
			if(v.is_a? Proc)
				hash[k] = v.call(doc)
			end
		end

		hash
	end

	private

		def sanitize_nokogiri(stuff)
			

			return stuff.to_s if(stuff.count == 1)

			result = []
			stuff.each{|a| result << a.to_s}
			result
		end
	

end
