Rails.application.routes.draw do

  root 'userstories#index'

  get '/help' => 'userstories#show'
  
  # get '[params: "short_url"]' => 'links#show'
  
  get '/sessions/new' => 'sessions#new', as: 'new_session'
  post '/sessions' => 'sessions#create'

  delete '/logout' => 'sessions#destroy'

  resources :links
  resources :users

end
