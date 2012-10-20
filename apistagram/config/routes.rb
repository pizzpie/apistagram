Apistagram::Application.routes.draw do
  root :to => "iphotos#index"

  resources  :auths,
             :iphotos

  resources :users, :only => [:show]             

  match '/auth/:provider/callback'  => 'auths#create'
  match '/auth/failure'             => 'auths#failure'
  match '/signin'                   => 'auths#new',      :as => :signin
  match '/signout'                  => 'auths#destroy',  :as => :signout
  match '/contact'                  => 'users#contact'
  match '/advertize'                => 'users#advertize'
  match '/report'                   => 'users#report'

  match '/contact'                  => 'users#contact',  :as => :contact, :via => :post
  match '/advertize'                => 'users#advertize',  :as => :advertize, :via => :post
  match '/report'                   => 'users#report',  :as => :report, :via => :post

  match '/users/:id/photos/:sort'   => 'users#show'
  match '/legal'   => 'users#legal', :as => :legal

  namespace :admin do
    resources :users, :only => [:index, :destroy]
    resources :iphotos
    root :to => "users#index"


    match "fetch_photos" => 'users#fetch_photos', :as => 'fetch_photos', :via => 'post'
    match "approve_photos" => 'iphotos#approve_photos', :as => 'approve_photos', :via => 'post'
  end

  match '/remove_all_photos/:id'  => 'users#remove_all_photos', :via => :delete, :as => 'remove_all_photos'
  match '/remove_user/:id'  => 'users#destroy', :via => :delete, :as => 'remove_user'
  match 'tatstagrams/:category'         => 'iphotos#index'
  match 'tatstagrams/:category/:sort'   => 'iphotos#index' 
  match 'iphotos/:id/favorite'    => 'iphotos#favorite', :via => 'get', :as => 'favorite'
  match 'iphotos/:id/add_comment' => 'iphotos#add_comment', :via => :post, :as => 'add_comment'
  match 'iphotos/:id/remove_comment/:comment_id' => 'iphotos#remove_comment', :via => :delete, :as => 'remove_comment'
  match 'login'                   => 'auths#new', :as => 'login' 
  match '/:id' => 'iphotos#show'
end
