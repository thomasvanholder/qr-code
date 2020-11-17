require "csv"
require "pry"

class LeadsCSV
  def initialize
    @csv_file =  File.join(__dir__, 'restaurants.csv')
    # @base_url = "https://www.herold.at/gelbe-seiten/#{keyword}/was_restaurant/?page_"
    # @keyword = keyword
    @elements = []
  end

  def load_csv
    csv_options = { col_sep: ',', headers: :first_row, header_converters: :symbol }
    p @csv_file
    CSV.foreach(@csv_file, csv_options) do |row|
      @elements << row.to_h
    end
    return @elements
  end
end
