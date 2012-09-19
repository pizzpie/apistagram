Apistagram::Application.routes.draw do
  root :to => "instagrams#index"

  resources  :auths,
             :instagrams

  match '/auth/:provider/callback'  => 'auths#create'
  match '/auth/failure'             => 'auths#failure'
  match '/signin'                   => 'auths#new',      :as => :signin
  match '/signout'                  => 'auths#destroy',  :as => :signout

  match 'tatstagrams/:type'			=> 'instagrams#index'
end
