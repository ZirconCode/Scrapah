

Scrapah
===

Note: Gem is not Published yet, being polished atm

Scrapah is a ruby gem for web scraping and flexible content extraction. Scrapah takes your Hashes, regex, xpath's, css, and even Proc's, and turns them into neat results. Scrapah is heavily based on Nokogiri.

Installation
---

	n/a

Using Scrapah
---

	s = Scrapah::Scraper.new :openuri
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


Todo
---

* !improve the caching
* Optional Requires (ex. watir-webdriver for some)
* proxy support
* recursive-autodiscovery, proxy-switching, and other 'patterns'
