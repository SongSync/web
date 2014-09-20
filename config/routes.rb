Rails.application.routes.draw do

  namespace :api, path: nil, defaults: {format: 'json'}, constraints: { subdomain: 'api' } do
    namespace :v1 do
      resources :users do
        resources :songs
      end
    end
  end

  devise_for :users
  root 'pages#home'
end
