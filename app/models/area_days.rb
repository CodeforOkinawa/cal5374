require 'csv'
require 'uri'
require 'open-uri'

class AreaDays
  class NotFound < StandardError; end

  AREA_COLUMN_NAME = "地名"
  CENTER_COLUMN_NAME = "センター"

  include Mem

  def initialize(url)
    @url = url
  end

  def find(area)
    csv.detect {|row|
      row[AREA_COLUMN_NAME] == area
    } or raise NotFound, "地名「#{area}」がurl「#{url}」で見つかりませんでした。"
  end

  private

  def csv
    CSV.parse(csv_content, headers: :first_row)
  end
  memoize :csv

  def csv_content
    response = OpenURI.open_uri(url)

    if response.status == ["200", "OK"]
      response.read
    else
      ""
    end
  rescue
    ""
  end
  memoize :csv_content

  def url
    URI.join(@url, 'data/area_days.csv')
  rescue
    @url
  end
  memoize :url
end
