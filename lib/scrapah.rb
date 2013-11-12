
# Agile Scraper

# uses simple caching, different methods of access, timeouts/error management, etc...
# will expand to gem perhaps

# Version 0.9 - It Works Great but Needs some Error Handling =)

# / ZirconCode

require 'nokogiri'
require 'open-uri'
require 'watir-webdriver'
require 'headless' # needs xvfb installed
require 'json' # yeah?


class Cache

	# TODO: 'throws away' whole cache after timeout, 
	# 	    -> treat entries as seperate objects/files/dates

	@@cache_dir = 'cache/'

	def initialize()
		Dir.mkdir(@@cache_dir) unless File.exists?(@@cache_dir)
		@Cache = Hash.new
		@keep_time = 1*24*60 # in minutes
	end

	def store(key,content)
		@Cache[key] = content
	end

	def get(key)
		@Cache[key]
	end

	def has_key?(key)
		@Cache.has_key? key
	end

	def clear()
		@Cache = Hash.new
	end

	def save
		# WARNING: Symbols converted to Strings
		f = File.new(@@cache_dir+Time.now.to_i.to_s,'w')
		JSON.dump(@Cache,f)
	end


	def load
		f = get_newest_acceptable
		@Cache = Hash.new
		@Cache = JSON.load(f) unless f.nil?
	end

	def get_hash
		@Cache
	end

	private

		def get_newest_acceptable()
			prev = Dir.glob(@@cache_dir+'*')
			if(!prev.empty?)
				prev.map!{|f| f.delete(@@cache_dir).to_i}
				prev.sort!
				return File.new(@@cache_dir+prev.last.to_s) if(Time.now.to_i-prev.last < @keep_time*60)
			end

			nil
		end

end


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

# TEST ----
def temporary_test
	s = Scraper.new :openuri
	s.start

	s.get('https://news.ycombinator.com/item?id=6709901') #random...

	results = Hash.new
	results[:name] = 'regex, or ruby code here.... hmm'
	results[:bleh] = /(...research...)/
	results[:code] = Proc.new{|d| d.css('a').count}
	results[:test] = Proc.new{|d| d.xpath("//span[@class='pagetop']/b").to_s}
	results[:tes2] = /\"user\?id=(.*?)\"/
	results[:tes3] = /noexisttest/
	results[:tes4] = "x|//span[@class='pagetop']/b"
	results[:tes5] = "x|//span[@class='pagetop']/a"
	results[:tes6] = "c|form"

	p s.process(results)

	s.stop

	puts 'finished'
end

temporary_test
# TEST ----