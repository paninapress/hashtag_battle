Hashtagbattle::Application.routes.draw do
  root "hashtags#index"
  resource :hashtags
  get "/auth/twitter/callback", to: 'sessions#create'
  get '/signout', to: 'sessions#destroy', as: 'signout'
  get 'auth/failure', to: redirect('/')
end
