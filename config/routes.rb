require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  devise_for :users
  root to: "contacts#index"
  
  resources :contacts, except: %i[new create]
  resources :imports, only: %i[index new create show update destroy] do
    member do
      get :pair_columns
    end
  end
end
