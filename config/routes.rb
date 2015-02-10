Rails.application.routes.draw do
  resources :users

  mount Resque::Server, at: "/resque"
  root to:'users#index'
end
