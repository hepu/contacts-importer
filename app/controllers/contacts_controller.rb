class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_contact!, only: %i[show destroy]

  def index
    @contacts = current_user.contacts.order(name: :asc).page(params[:page]).per(params[:per_page])
  end
  
  def show; end
  
  def destroy
    @contact.destroy!

    flash[:success] = 'Contact deleted'
    redirect_to action: :index
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to @contact
  end
  
  private
  
  def find_contact!
    @contact = current_user.contacts.find_by!(id: params[:id])
  end
end
