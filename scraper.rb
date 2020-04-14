require 'nokogiri'
require 'httparty'
require 'byebug'
require 'awesome_print'

def scraper(city)
    url = "https://#{city.downcase}.craigslist.org/search/apa?min_bedrooms=3&max_bedrooms=3&min_bathrooms=2&max_bathrooms=2&availabilityMode=0&sale_date=all+dates"
    unparsed_page = HTTParty.get(url)
    parsed_page = Nokogiri::HTML(unparsed_page)

    # totalcount = parsed_page.css('span.totalcount')[0].text.to_i
    # range = parsed_page.css('span.rangTo')[0].text.to_i
    listings = parsed_page.css('a.result-title')

    info_arr = []
    listings.each.with_index do |list, i|
        title = parsed_page.css('a.result-title')[i]
        rent = parsed_page.css('span.result-price')[i]
        address = parsed_page.css('span.result-hood')[i]
        list_info = {
            title: title ? title.text : "",
            rent:  rent ? rent.text : "",
            address: address ? address.text : ""
        }
        info_arr << list_info
    end
   ap info_arr
end

scraper("atlanta")