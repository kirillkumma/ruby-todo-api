# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :todos
      post 'register', to: 'auth#register'
      post 'login', to: 'auth#login'
      post 'authenticate', to: 'auth#authenticate'
    end
  end
end
