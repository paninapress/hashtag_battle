Hashtagbattle::Application.routes.draw do
  root "sites#index"

  post '/challenges', to: 'challenges#create'
  get '/challenges', to: 'challenges#index'


  get "/auth/twitter/callback", to: 'sessions#create'
  get '/signout', to: 'sessions#destroy', as: 'signout'
  get 'auth/failure', to: redirect('/')
end
