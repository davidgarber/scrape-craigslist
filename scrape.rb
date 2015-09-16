require 'rubygems'
require 'mechanize'
require 'pry-byebug'
require 'csv'

scraper = Mechanize.new
#  callback, method that runs each page, slep so not ddos
scraper.history_added = Proc.new{sleep 0.5}
BASE_URL = 'http://sfbay.craigslist.org/'
# ADDRESS is a constant that represents starting address of scraper
ADDRESS = 'http://sfbay.craigslist.org/search/apa'

scraper.get(ADDRESS) do search_page
  search_form = search_page.form_with(:id => 'searchform') do |search|
    search.query = "Garden Apartment"
    search.min_price = 1000
    search.max_price = 5000
end
