require 'rubygems'
require 'mechanize'
require 'pry-byebug'
require 'csv'
require 'nokogiri'

scraper = Mechanize.new
#  callback, method that runs each page, slep so not ddos
scraper.history_added = Proc.new {sleep 0.5}
BASE_URL = 'http://sfbay.craigslist.org/'
# ADDRESS is a constant that represents starting address of scraper
ADDRESS = 'http://sfbay.craigslist.org/search/apa'
results = []

scraper.get(ADDRESS) do |search_page|
  search_form = search_page.form_with(:id => 'searchform') do |search|
    search.query = "Garden Apartment"
    search.min_price = 1000
    search.max_price = 5000
  end
    results_page =search_form.submit

    raw_results = result_page.search('p.row')
    raw_results.each do |result|
        link = result.search('a')[1]
        name = link.text.strip
        url = 'http://sfbay.craigslist.org/' + link.attributes["href"].value
        price = result.search('span.price').text
        location = result.search('span.pnr').text[3][-13]

        results << [name, url, price, location]
end
