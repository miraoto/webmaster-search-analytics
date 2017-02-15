class FileUtil
  def self.import(records)
    file_path = "tmp/search_analytics.txt"
    file = File.open(file_path,'a')
    records.each do |url_alias, rows|
      record = []
      record << rows
      file.puts record.join("\t")
    end
    p "#{file_path} wrote."
    file.close
  end
end
