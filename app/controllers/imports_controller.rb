class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_import!, only: %i[show update destroy]

  def index
    @imports = user_imports
  end

  def new
    @import = current_user.imports.new
  end
  
  def create
    @import = current_user.imports.new(create_params)
    @import.save!

    flash[:success] = "Import created successfully!"
    redirect_to import_pair_columns_path(@import)
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to action: :new
  end
  
  def show
    load_column_pairings
    load_csv_headers
  end
  
  def update
    @import.update!(update_params)

    respond_to do |format|
      format.turbo_stream do
        load_column_pairings
        load_csv_headers
        @autoupdate_form = params[:autoupdate_form] == 'true' ? true : false
      end
      format.html do
        if params[:schedule_job].present?
          @import.restart!
          ImportContactsJob.perform_later(@import.id, current_user.id)
          flash[:success] = "Contacts are now being imported!"
        else
          flash[:success] = "Columns paired successfully!"
        end
        redirect_to import_path(@import)
      end
    end

  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to @import
  end
  
  def destroy
    @import.destroy!

    flash[:success] = "Import deleted successfully"
    redirect_to action: :index
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to @import
  end
  
  private
  
  def create_params
    params.require(:import).permit(%i[file])
  end
  
  def update_params
    params.require(:import).permit(:created_at, {
      column_pairings_attributes: %i[csv_column local_column position _destroy id]
    })
  end
  
  def find_import!
    @import = current_user.imports.includes(:column_pairings).find_by!(id: params[:id])
  rescue StandardError => e
    flash[:error] = "Import not found"
    redirect_to action: :index
  end

  def user_imports
    current_user.imports.order(created_at: :desc).page(params[:page]).per(params[:per_page])
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
