Apistagram::Application.routes.draw do
  root :to => "instagrams#index"

  resources  :auths,
             :instagrams

  match '/auth/:provider/callback'  => 'auths#create'
  match '/auth/failure'             => 'auths#failure'
  match '/signin'                   => 'auths#new',         :as => :signin
  match '/signout'                  => 'sessions#destroy',  :as => :signout
end
