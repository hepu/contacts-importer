class CsvHeadersForFileService
  def initialize(file)
    @file = file
  end

  def call
    require 'csv'

    csv = CSV.parse(@file.download, headers: true, encoding: 'UTF-8')
    
    csv.headers
  end
end