class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_import!, only: %i[show pair_columns update destroy]

  def index
    @imports = current_user.imports.order(created_at: :desc).page(params[:page]).per(params[:per_page])
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
  
  def show; end
  
  def update
    @import.update!(update_params)
    
    if params[:schedule_job].present?
      ImportContactsJob.perform_later(@import.id, current_user.id)
      flash[:success] = "Contacts are now being imported!"
    else
      flash[:success] = "Columns paired successfully!"
    end

    redirect_to import_path(@import)
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
end
