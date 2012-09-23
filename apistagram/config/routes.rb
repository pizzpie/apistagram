Apistagram::Application.routes.draw do
  root :to => "iphotos#index"

  resources  :auths,
             :iphotos

  match '/auth/:provider/callback'  => 'auths#create'
  match '/auth/failure'             => 'auths#failure'
  match '/signin'                   => 'auths#new',      :as => :signin
  match '/signout'                  => 'auths#destroy',  :as => :signout

  match 'tatstagrams/:type'			=> 'iphotos#index'
end
