# frozen_string_literal: true

Rails.application.routes.draw do
  resources :books
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resource :users, only: :create
  post '/login', to: 'users#login'
end
