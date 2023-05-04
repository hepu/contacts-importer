class Imports::PairColumnsController < ApplicationController
  before_action :find_import

  def show
    load_column_pairings
    load_csv_headers
  end

  private

  def update_params
    params.require(:import).permit({
      column_pairings: %i[csv_column local_column _destroy]
    })
  end

  def find_import
    @import = current_user.imports.includes(:column_pairings).find_by(id: params[:import_id])
  end

  def load_column_pairings
    @column_pairings = @import.column_pairings.order(local_column: :asc)
  end

  def load_csv_headers
    csv_file_headers = CsvHeadersForFileService.new(@import.file).call
    current_csv_columns = @column_pairings.pluck(:csv_column)

    @csv_headers = current_csv_columns.compact + csv_file_headers.reject { |h| current_csv_columns.include?(h) }
  end
end
