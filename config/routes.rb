Rails.application.routes.draw do
  devise_for :users
  root to: "contacts#index"
  
  resources :contacts
end
