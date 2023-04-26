class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_import!, only: %i[show pair_columns update destroy schedule_import clear_logs]

  def index
    @imports = user_imports
  end

  def new
    @import = Import.new(user: current_user)
  end
  
  def create
    @import = Import.new(create_params)
    @import.user = current_user
    @import.save!

    flash[:success] = "Import created successfully!"
    redirect_to pair_columns_import_path(@import, continue: true)
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to action: :new
  end
  
  def pair_columns
    @csv_headers = CsvHeadersForFileService.new(@import.file).call
    @contact_attributes = Import::UPLOADABLE_ATTRIBUTES.sort
    @continue = params[:continue].present?
  end
  
  def show
    @csv_headers = CsvHeadersForFileService.new(@import.file).call
    @contact_attributes = Import::UPLOADABLE_ATTRIBUTES.sort
  end
  
  def update
    @import.update!(update_params)

    respond_to do |format|
      format.turbo_stream do
        @csv_headers = CsvHeadersForFileService.new(@import.file).call
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
    redirect_to action: :pair_columns, continue: params[:schedule_job].present?
  end
  
  def destroy
    @import.destroy!

    flash[:success] = "Import deleted successfully"
    redirect_to action: :index
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to @import
  end

  def schedule_import
    @import.restart!
    ImportContactsJob.perform_later(@import.id, current_user.id)

    respond_to do |format|
      format.html do
        flash[:success] = "Import scheduled to process!"
        redirect_to import_path(@import)
      end
    end
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to import_path(@import)
  end

  def clear_logs
    @import.clear_logs
    @import.save!

    respond_to do |format|
      format.turbo_stream
      format.html do
        flash[:success] = "Logs cleared!"
        redirect_to import_path(@import)
      end
    end
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to import_path(@import)
  end
  
  private
  
  def create_params
    params.require(:import).permit(%i[file])
  end
  
  def update_params
    params.require(:import).permit({columns_pair: %i[address birthdate credit_card_number email name phone]})
  end
  
  def find_import!
    @import = current_user.imports.find_by!(id: params[:id])
  rescue StandardError => e
    flash[:error] = "Import not found"
    redirect_to action: :index
  end

  def user_imports
    current_user.imports.order(created_at: :desc).page(params[:page]).per(params[:per_page])
  end
end
