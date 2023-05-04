require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations'
  }
  root to: "contacts#index"
  
  resources :contacts, only: %i[index show destroy]
  resources :imports do
    scope module: :imports do
      resource :pair_columns, only: :show
      resource :schedules, only: :create
      resource :clear_logs, only: :destroy
    end
  end
end
