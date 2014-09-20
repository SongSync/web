Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users do
        resources :songs
      end
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
end
