Rails.application.routes.draw do

  root 'userstories#index'

  get '/help' => 'userstories#show'
    
  get '/sessions/new' => 'sessions#new', as: 'new_session'
  post '/sessions' => 'sessions#create'

  get '/api/inventory' => 'items#index'
  get 'api/inventory/:sku' => 'items#show'
  post 'api/inventory/' => 'items#create'

  get '/user/show' => 'users#show'

  delete '/logout' => 'sessions#destroy'
  delete '/users/remove' => 'users#destroy'

  resources :items
  resources :apikeys
  resources :users

end
