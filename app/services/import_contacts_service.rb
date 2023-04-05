class ImportContactsService
  def initialize(import)
    @import = import
  end

  def call
    require 'csv'

    csv = CSV.parse(@import.file.download, :headers => true)
    
    csv.each_with_index do |row, index|
      ActiveRecord::Base.transaction do
        
      end
    end
  end
end