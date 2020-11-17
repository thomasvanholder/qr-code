require "open-uri"
require 'nokogiri'

class ScrapeAllRecipes
  def initialize(keyword)
    @base_url = "https://www.herold.at/gelbe-seiten/#{keyword}/was_restaurant/?page="
    @restaurants = []
  end

  def call
    1.times do |num|
      count = num + 1
      url = @base_url + count.to_s
      p url
      puts "-------------------"
      html_file = open(url).read
      doc = Nokogiri::HTML(html_file)

      doc.search(".result-item").take(3) do |element|
        title = element.search("h2").text.strip
        category = element.search(".heading").text.strip
        address = element.search(".address").text.strip
        # -----------
        restaurant_link = element.attribute("data-detail-url").value
        restaurant_html_file = open(restaurant_link).read
        restaurant_doc = Nokogiri::HTML(restaurant_html_file)
        email = ''
        if restaurant_doc.search("a.ellipsis").attribute("href")
          email = restaurant_doc.search("a.ellipsis").attribute("href").value
          email = email.split('mailto:')[1]
        end

        puts "#{title}, @ #{email}"
        # -----------
        @restaurants << { name: title, category: category, address: address, email: email, source: "Harold at" }
      end
      puts "-------------------"
      puts "PAGE #{count} -- #scraped: #{@restaurants.count}"
    end
    puts "-------------------"
    puts "TOTAL restaurants scraped: #{@restaurants.count} \n ------------------"
    save_to_db
  end

  def save_to_db
    @restaurants.each do |restaurant|
      Lead.create!(restaurant)
    end
  end
    # csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
    # filepath = "/restaurants.csv"

    # CSV.open(filepath, 'wb', csv_options) do |csv|
    #   @restaurants.each do |res|
    #     csv << [res[:name], res[:category], res[:address], res[:email], res[:source]]
    #   end
  # end
end

def start
  puts "start time is #{Time.now}"
  puts "----------------------"
  scraper = ScrapeAllRecipes.new("wien")
  scraper.call
  puts "----------------------"
  puts "end time is #{Time.now}"
end

start
