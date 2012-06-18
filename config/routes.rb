Agreatfirstdate::Application.routes.draw do
  root :to => 'welcome#index'

  post '/stripe' => 'stripe#web_hook', as: :stripe_web_hook

  resources :profiles, :only => [:show] do
    post 'send_email', on: :member
    put 'activate', on: :member
    put 'deactivate', on: :member
    put 'still_inappropriate', on: :member
  end

  get '/me'                 => 'my_profile#show',           :as => :my_profile
  get '/me/points'          => 'my_profile#points',         :as => :my_points
  get '/me/edit'            => 'my_profile#edit',           :as => :edit_profile
  get '/me/geo'             => 'my_profile#geo',            :as => :geo_profile
  put '/me'                 => 'my_profile#update',         :as => :update_profile
  put '/me/billing'         => 'my_profile#update_billing', :as => :update_billing
  post '/me/select_pillars' => 'my_profile#select_pillars', :as => :select_pillars
  get '/me/facebook_albums' => 'my_profile#facebook_albums'
  get '/me/facebook_album/:aid' => 'my_profile#facebook_album'  

  devise_for :users, 
    :controllers => { 
      :registrations => "registrations", 
      :omniauth_callbacks => "omniauth_callbacks"
    }
  
  devise_scope :user do
    get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
    get '/users/confirm_email' => 'registrations#confirm_email'
  end
  
  post '/store_settings' => 'users#store_settings', as: :store_settings

  get "welcome/index"
  get "welcome/about"
  get "welcome/blog"
  get "welcome/faq"
  get "welcome/privacy"
  get "welcome/terms"
  post "welcome/send_feedback"

  resources :pillars do
    resources :event_types, only: :index, on: :member do
      resources :event_descriptors, only: :index, on: :member
    end
    resources :event_items, only: [:index, :create, :update], on: :member
  end

  resources :event_items do
    put 'activate', on: :member
    put 'deactivate', on: :member
    put 'still_inappropriate', on: :member
  end

  resources :event_photos

  resources :event_types do
    resources :event_descriptors, only: :index, on: :member
  end

  resources :avatars, only: :update
  resources :searches, only: [:index] do
    get :opposite_sex, on: :collection
  end

  resources :inappropriate_contents, only: [] do
    put :fix, on: :member
  end
end
