class Imports::SchedulesController < ApplicationController
  before_action :find_import

  def create
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

  private

  def find_import
    @import = current_user.imports.find_by(id: params[:import_id])
  end
end
