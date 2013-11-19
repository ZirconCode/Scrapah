

Scrapah
===

Scrapah is a ruby gem for web scraping and flexible content extraction. Scrapah takes your Hashes, regex, xpath's, css, and even Proc's, and turns them into neat results. Scrapah is heavily based on Nokogiri.

Installation
---

	gem install Scrapah

    # running in :headless requires xvfb to be installed on your system 
    # for details, see gem at https://github.com/leonid-shevtsov/headless
    # > sudo apt-get install xvfb


Using Scrapah
---

**Start** a Scraper

	require 'scrapah'

	# use :headless to use a browser in background
	s = Scrapah::Scraper.new :openuri 
	s.start

Tell Scrapah where to **go**

	s.visit 'https://github.com/ZirconCode'

You can pass in a **regex**

	# ex. get my total contributions on github
	p s.process /\b(\d*?) Total\b/

Scrapah will treat a string beginning with 'c|' as a **CSS** selector

	# ex. get the title tag off a page
	p s.process 'c|h1'

Scrapah will treat a string beginning with 'x|' as an **XPath**

	# ex. get my popular repositories
	p s.process 'x|//span[@class="repo"]/text()'

Scrapah will even take your **Proc's**

	# ex. Extract all emails from a website
	p s.process Proc.new{|nokogiri_doc| Scrapah::Extract.emails nokogiri_doc}

The Magic: Pass in a **Hash** of stuff, get results

	s.visit 'https://github.com/ZirconCode'

	profile = Hash.new
	profile[:name]          = Proc.new{|d| 'The Great '+d.xpath('x|//span[@class="vcard-username"]/text()').to_s}
	profile[:total_contrib] = /\b(\d*?) Total\b/
	profile[:join_date]     = 'x|//span[@class="join-date"]/text()'
	profile[:popular_repos] = 'x|//span[@class="repo"]/text()'
	profile[:website]       = 'x|//a[@class="url"]/text()'

	p s.process(profile) # ^_^

Don't forget to stop Scrapah at the end =)

	s.stop


Development
---

    git clone https://github.com/ZirconCode/Scrapah.git
    cd Scrapah

    bundle install

    # to install gem locally
    rake install

	# Pull requests are welcome =)


Todo
---

* !improve the caching
* Optional Requires (ex. watir-webdriver for some)
* proxy support
* recursive-autodiscovery, proxy-switching, and other 'patterns'
