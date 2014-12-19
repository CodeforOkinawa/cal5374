require 'csv'
require 'uri'
require 'open-uri'

class AreaDays
  AREA_COLUMN_NAME = "地名"

  def initialize(url)
    @url = url
  end

  def find(area)
    csv.detect {|row| row[AREA_COLUMN_NAME] == area }.to_h
  end

  private

  def csv
    CSV.parse(csv_content, headers: :first_row)
  end

  def csv_content
    response = OpenURI.open_uri(url)

    if response.status == ["200", "OK"]
      response.read
    else
      ""
    end
  end

  def url
    URI.join(@url, 'data/area_days.csv')
  end
end
