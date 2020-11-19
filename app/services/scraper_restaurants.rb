require "open-uri"
require 'nokogiri'

class ScraperRestaurants
  def initialize(keyword, pagina)
    @base_url = "https://www.herold.at/gelbe-seiten/#{keyword}/was_restaurant/?page="
    @pagina = pagina
    @restaurants = []
  end

  def call
    100.times do |num|
      count = @pagina + num
      url = @base_url + count.to_s
      p "URL >>> " + url
      puts "-------------------"
      html_file = open(url).read
      doc = Nokogiri::HTML(html_file)

      doc.search(".result-item").each_with_index do |element, index|
        title = element.search("h2").text.strip
        category = element.search(".heading").text.strip
        address = element.search(".address").text.strip
        # go to restaurant show page and scrape email
        restaurant_link = element.attribute("data-detail-url").value
        restaurant_html_file = open(restaurant_link).read
        restaurant_doc = Nokogiri::HTML(restaurant_html_file)
        email = ''
        if restaurant_doc.search("a.ellipsis").attribute("href")
          email = restaurant_doc.search("a.ellipsis").attribute("href").value
          email = email.split('mailto:')[1]
        end

        puts "#{count}..#{index + 1} --  #{title}, @ #{email}"
        # -----------
        @restaurants << { name: title, category: category, address: address, email: email, source: "harold.at" }
      end
      puts "-------------------"
      puts "PAGE #{count} -- #scraped: #{@restaurants.count}"
    end
    puts "-------------------"
    puts "TOTAL restaurants scraped: #{@restaurants.count} \n ------------------"
    return @restaurants
  end
end
