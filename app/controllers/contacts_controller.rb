class ContactsController < ApplicationController
  before_action :authenticate_user!

  def index
    @contacts = current_user.contacts.order(name: :asc).page(params[:page]).per(params[:per_page])
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
