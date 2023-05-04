class Imports::ClearLogsController < ApplicationController
  before_action :find_import

  def destroy
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

  def find_import
    @import = current_user.imports.find_by(id: params[:import_id])
  end
end
