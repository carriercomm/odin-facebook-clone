Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations',  :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_scope :user do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
    get '/register' => 'devise/registrations#new'
    get '/settings' => 'devise/registrations#edit'
  #  delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session

  end

  root 'static_pages#home'

  resources :posts, only: [:create, :update, :delete, :edit, :update]
  resources :users, only: [:show, :index] do
    resources :posts, except: [:index, :create, :delete]
  end

  resources :likes, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]
  resources :comments, only: [:create, :edit, :update, :destroy]
  get 'friend_requests', to: 'friendships#friend_requests', as: 'friend_requests'
  post 'friend_requests', to: 'friendships#confirm_request', as: 'confirm_request'
  get '/friends', to: 'friendships#index', as: 'friends'

end
