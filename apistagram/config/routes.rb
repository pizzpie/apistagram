Apistagram::Application.routes.draw do
  root :to => "iphotos#index"

  resources  :auths,
             :iphotos

  resources :users, :only => [:show]             

  match '/auth/:provider/callback'  => 'auths#create'
  match '/auth/failure'             => 'auths#failure'
  match '/signin'                   => 'auths#new',      :as => :signin
  match '/signout'                  => 'auths#destroy',  :as => :signout

  namespace :admin do
    resources :users, :only => [:index, :destroy]
    resources :iphotos
    root :to => "users#index"


    match "fetch_photos" => 'users#fetch_photos', :as => 'fetch_photos', :via => 'post'
    match "approve_photos" => 'iphotos#approve_photos', :as => 'approve_photos', :via => 'post'
  end

  match 'tatstagrams/:type'			  => 'iphotos#index'
  match 'iphotos/:id/favorite'    => 'iphotos#favorite', :via => 'get', :as => 'favorite'
  match 'iphotos/:id/add_comment' => 'iphotos#add_comment', :via => :post, :as => 'add_comment'
  match 'login'                   => 'auths#new', :as => 'login'
end
