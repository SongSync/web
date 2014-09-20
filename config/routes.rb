Rails.application.routes.draw do
  # Devise
  devise_for :users, controllers: { sessions: 'api/v1/sessions' }

  # Api Auth
  devise_scope :user do
    post '/api/v1/users/sign_in' => 'api/v1/sessions#create'
    delete '/api/v1/users/sign_out' => 'api/v1/sessions#destroy'
  end

  # API Controllers
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :songs
      resources :playlists
      resources :users
    end
  end

  # Manual pages
  match '/play', to: 'pages#player', via: :get

  # API matches
  match '/auth/:provider/callback', to: 'sessions#create', via: :get
  match '/partial/(*name)', to: 'pages#partial', via: :get

  root 'pages#player', via: :get
end
