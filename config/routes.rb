require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
    confirmations: 'users/confirmations',
  }
  root to: "contacts#index"
  
  resources :contacts, only: %i[index show destroy]
  resources :imports, only: %i[index new create show update destroy] do
    member do
      get :pair_columns
      post :schedule_import
      delete :clear_logs
    end
  end
end
