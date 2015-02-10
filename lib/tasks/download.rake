begin
  require 'nokogiri'
  require 'open-uri'
rescue LoadError
  # do nothing
end

desc '各地の5374.jpのdata.csvをダウンロードします'
task download: :environment do
  dir = File.join(%w(public 5374))
  unless Dir.exist?(dir)
    Dir.mkdir(dir)
  end

  index_url = 'http://5374.jp/publicity.html'
  html = open(index_url).read
  doc = Nokogiri.parse(html.force_encoding(Encoding::UTF_8))
  urls = Hash[doc.css('#u524_align_to_page a').map {|a| [a.text, a[:href]] }]
  urls = urls.reject {|k, _| k == "各地への広がり" }
  urls['川崎市'] = 'http://kawasaki.5374.jp'

  urls.each do |name, url|
    host = URI.parse(url).host
    path = Rails.root.join(dir, host)

    if File.exist?(path)
      next
    end

    csv_url = AreaDays.new(url).url

    puts name
    puts csv_url

    begin
      response = OpenURI.open_uri(csv_url)
      unless response.status == %w(200 OK)
        puts 'ダウンロードに失敗しました'
        next
      end
    rescue OpenURI::HTTPError => e
      puts e
      next
    end

    File.write(path, response.read, encoding: 'binary:binary')
  end
end
