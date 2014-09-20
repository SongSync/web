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

  # Web App Controllers
  resources :pages, only: [] do
    collection do
      get :home
      get :player
    end
  end

  # Manual matches
  match '/auth/:provider/callback', to: 'sessions#create', via: 'get'
  match '/partial/(*name)', to: 'pages#partial', via: :get

  root 'pages#home'
end
