Rails.application.routes.draw do
  resources :cities
  root to: 'cities#index'
  get '/admin', to: 'cities#index', default: {:admin => true}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
