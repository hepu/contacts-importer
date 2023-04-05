class ImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_import!, only: %i[show pair_columns update]

  def index
    @imports = current_user.imports
  end

  def new
    @import = Import.new(user: current_user)
  end
  
  def create
    @import = Import.new(create_params)
    @import.user = current_user
    @import.save!

    flash[:success] = "Import created successfully!"
    redirect_to pair_columns_import_path(@import)
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to action: :new
  end
  
  def pair_columns
    @csv_headers = CsvHeadersForFileService.new(@import.file).call
    @contact_attributes = Contact::UPLOADABLE_ATTRIBUTES
  end
  
  def show
    
  end
  
  def update
    @import.update!(update_params)

    flash[:success] = "Columns paired successfully!"
    redirect_to import_path(@import)
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to action: :pair_columns
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
