Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      devise_for :users, controllers: { registrations: 'api/v1/registrations', sessions: 'api/v1/sessions' }
      resources :songs, controller: '/api/v1/songs'
      resources :playlists
    end
  end

  match '/auth/:provider/callback', to: 'sessions#create', via: 'get'

  devise_for :users
  root 'pages#home'
  resources :pages, only: [] do
    collection do
      get :home
      get :player
    end
  end

  match '/partial/(*name)', to: 'pages#partial', via: :get
end
