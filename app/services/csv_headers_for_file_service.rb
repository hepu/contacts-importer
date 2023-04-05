class CsvHeadersForFileService
  def initialize(file)
    @file = file
  end

  def call
    require 'csv'

    csv = CSV.parse(@file.download, :headers => true)
    
    csv.headers
  end
end