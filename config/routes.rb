Rails.application.routes.draw do
  devise_for :users
  root to: "contacts#index"
  
  resources :contacts, except: %i[new create]
  resources :imports, only: %i[index new create show update] do
    member do
      get :pair_columns
    end
  end
end
