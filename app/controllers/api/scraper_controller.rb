class Api::ScraperController < ApplicationController

    def index
        city = params[:scraper][:city]
        send_data scraper("atlanta"), filename: "#{city.capitalize}_CL_3_Bedroom_2_Bathroom.csv"
    end

    private
    def scraper(city)
        url = "https://#{city.downcase}.craigslist.org/search/apa?availabilityMode=0&max_bathrooms=2&max_bedrooms=3&min_bathrooms=2&min_bedrooms=3"
        unparsed_page = HTTParty.get(url)
        parsed_page = Nokogiri::HTML(unparsed_page)

        listings = parsed_page.css('a.result-title')
        list_count = listings.count
        total_count = parsed_page.css('span.totalcount')[0].text.to_i
        rangeStart = 0
        # last page will be the remainder 
        rangeEnd = total_count - (total_count % list_count)


        file = CSV.generate do |csv|
            csv << ["Title", "Rent", "Address", "URL"]
            while rangeStart < rangeEnd
                pagination_url = "https://#{city.downcase}.craigslist.org/search/apa?s=#{rangeStart}&availabilityMode=0&max_bathrooms=2&max_bedrooms=3&min_bathrooms=2&min_bedrooms=3"
                unparsed_current_page = HTTParty.get(pagination_url)
                parsed_current = Nokogiri::HTML(unparsed_current_page)
                listings.each.with_index do |list, i|
                    title = parsed_current.css('a.result-title')[i]
                    rent = parsed_current.css('span.result-price')[i]
                    address = parsed_current.css('span.result-hood')[i]
            
                    list_info = [
                        title ? title.text : "",
                        rent ? rent.text : "",
                        address ? address.text.tr('()', '').strip : "",
                        title ? title.attributes["href"].value : ""
                    ]
                    
                    csv << list_info
            
                end
                rangeStart += list_count
            end
        end
        return file
    end
end
