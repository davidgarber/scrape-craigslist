require 'rubygems'
require 'mechanize'
require 'pry-byebug'
require 'csv'
require 'nokogiri'

scraper = Mechanize.new

# Mechanize setup to rate limit your scraping to once every half-second
scraper.history_added = Proc.new {sleep 0.5}

BASE_URL = 'http://sfbay.craigslist.org/'
# hard-coding an address for your scraper
ADDRESS = 'http://sfbay.craigslist.org/search/apa'

results = []

#scraping
scraper.get(ADDRESS) do |search_page|

  #work with the form
  search_form = search_page.form_with(:id => 'searchform') do |search|
    search.query = "Garden Apartment"
    search.min_price = 1000
    search.max_price = 5000
  end
    result_page =search_form.submit

    #get the results
    raw_results = result_page.search('p.row')

    #parse the results
    raw_results.each do |result|
        link = result.search('a')[1]

        name = link.text.strip
        url = 'http://sfbay.craigslist.org/' + link.attributes["href"].value
        price = result.search('span.price').text
        location = result.search('span.pnr').text[3][-13]

        #save the results
        results << [name, url, price, location]
  end

  CSV.open("filename.csv", "w+") do |csv_file|
    results.each do |row|
      csv_file << row
    end
  end
end
