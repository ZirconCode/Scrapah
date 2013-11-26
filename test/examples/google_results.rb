

require 'scrapah'
require 'uri'

# !Unfinished

# Example Scrapah Use Script
# Naturally Scraping Google Results

# TODO move "task" system under autodiscovery into scrapah

def google_results(query,amount)

	s = Scrapah::Scraper.new :type => :headless
	s.start

	tasks = []
	tasks << 'https://www.google.com/search?q='+URI.encode(query)
	discovery = Proc.new {|d| d.css('td.b a').first['href']}
	
	results = []

	while(results.size < amount && !tasks.empty?)
		puts s.get tasks.shift

		puts tasks
		puts 'sdf'

		tasks << s.process(discovery)
		puts tasks
		puts 'blah'
		tasks.map!{|t| t='https://www.google.com'+t if t.start_with?('/')}
		tasks = tasks.uniq.flatten
	end



	s.stop

end



p google_results("ruby gem scrapah",100)


