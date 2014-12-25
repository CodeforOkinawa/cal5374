require 'csv'

desc 'ダウンロードしたファイルをサポートしているか調べる'
task support: :environment do
  csv_paths = Dir[Rails.root.join(File.join(%w(public 5374 *)))]
  csv_paths.each do |csv_path|
    csv_content = File.read(csv_path)
    csv = CSV.parse(csv_content, headers: :first_row)
    garbage_columns = csv.headers.reject {|h|
      %w(町名 地名 センター).any?(&h.try(:method, :include?))
    }
    schedule = csv.to_enum(:each).map {|row|
      row.to_h.values_at(*garbage_columns)
    }.join
    supported = schedule.chars.all? {|c|
      c.blank? || c.in?(%w(月 火 水 木 金 土 日 0 1 2 3 4 5 6 7 8 9))
    }
    unless supported
      host = File.basename(csv_path)
      puts "#{host}はサポートされていません。"
    end
  end
end
