Rails.application.routes.draw do
  devise_for :users
  root to: "contacts#index"
  
  resources :contacts, except: %i[new create]
  resources :imports, only: %i[index new create show]
end
