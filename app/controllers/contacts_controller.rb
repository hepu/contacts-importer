class ContactsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_contact!, only: %i[show destroy]

  def index
    @contacts = user_contacts
  end
  
  def show; end
  
  def destroy
    @contact.destroy!

    respond_to do |format|
      format.turbo_stream do
        @contacts = user_contacts
      end
      format.html do
        flash[:success] = 'Contact deleted'
        redirect_to action: :index
      end
    end
  rescue StandardError => e
    flash[:error] = "Error: #{e.message}"
    redirect_to @contact
  end
  
  private
  
  def find_contact!
    @contact = current_user.contacts.find_by!(id: params[:id])
  end

  def user_contacts
    current_user.contacts.order(name: :asc).page(params[:page]).per(params[:per_page])
  end
end
