class ImportsController < ApplicationController
  before_action :authenticate_user!

  def index
    @imports = current_user.imports
  end

  def new
    @import = Import.new(user: current_user)
  end
  
  def create
    @import = Import.new(import_params)
    @import.user = current_user
    @import.save!

    flash[:success] = "Import created successfully!"
    redirect_to @import
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to action: :new
  end
  
  def show
    @import = current_user.imports.find_by!(id: params[:id])
  end
  
  private
  
  def import_params
    params.require(:import).permit(%i[file])
  end
end
