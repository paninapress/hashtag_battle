Hashtagbattle::Application.routes.draw do
  root "sites#index"
  resource :challenges do
    resource :hashtags
  end
  get "/auth/twitter/callback", to: 'sessions#create'
  get '/signout', to: 'sessions#destroy', as: 'signout'
  get 'auth/failure', to: redirect('/')
end
