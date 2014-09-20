Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: { sessions: 'api/v1/sessions' }

  # API Controllers
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users do
        resources :songs
      end
    end
  end

  # Manual pages
  match '/play', to: 'pages#player', via: :get

  # API matches
  match '/auth/:provider/callback', to: 'sessions#create', via: :get
  match '/partial/(*name)', to: 'pages#partial', via: :get

  root 'pages#home'
end
