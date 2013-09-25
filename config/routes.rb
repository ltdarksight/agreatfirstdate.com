Agreatfirstdate::Application.routes.draw do
  namespace :api do

    # Version 1
    namespace :v1 do
      post   'users/sign_in' => 'sessions#create'
      delete 'users/sign_out'=> 'sessions#destroy'

      resources :profiles, only: [:show] do
        collection do
          get 'me'
          put 'me' => 'profiles#me_update'
        end
      end
      resources :pillars, only: :show
      resources :events, only: [:create, :show, :update, :destroy]
    end

    resources :instagram, only: [:index] do
      collection do
        get :media
      end
    end
    resource :permissions, only: [:index]
    namespace :facebook do
      resources :albums, only: [:index, :show]
    end

    resources :strikes, only: [:create]
    resources :favorites, only: [ :index, :create, :destroy ]

    resources :users
    resources :searches, only: [:index] do
      get 'opposite_sex' => 'searches#opposite_sex', on: :collection
    end
    resources :profiles do
      collection do
        post 'send_email'
        get 'avatars' => 'avatars#index'
        post 'avatars' => 'avatars#create'
        delete 'avatars/:id' => 'avatars#destroy'
        put "avatars/:id" => "avatars#update"
      end
      member do
        put :deactivate
        get :activate
      end
    end
    resources :event_items, only: [:create, :update, :destroy]
    resources :pillars do
      resources :event_types, only: [:index]
    end
    resources :event_photos
    resource :pillar_categories, only: [:update]
    get '/geo_lookup' => 'geo_lookup#index'
    get '/discount' => 'discount#index'
    get '/me' => 'profiles#me'
    put '/me' => 'profiles#update'
    resource :billing, :only => [:show, :update, :destroy], :controller => "billing"

  end

  root :to => 'welcome#index'

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
  put '/me/cancel'          => 'my_profile#cancel',         :as => :cancel_account
  post '/me/select_pillars' => 'my_profile#select_pillars', :as => :select_pillars
  get '/me/facebook_albums' => 'my_profile#facebook_albums'
  get '/me/instagram_photos' => 'my_profile#instagram_photos'
  get '/me/facebook_album/:aid' => 'my_profile#facebook_album'

  devise_for :users,
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations',
      omniauth_callbacks: 'omniauth_callbacks'
    }

  devise_scope :user do
    get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
    get '/users/confirm_email' => 'registrations#confirm_email'
    post '/users/confirm_email' => 'registrations#confirm_email'
  end

  post '/store_settings' => 'users#store_settings', as: :store_settings

  get 'blog' => 'blog#index'
  get 'blog/:alias' => 'blog#show', as: :blog_post
  resources :posts, only: [:new, :edit, :update, :create, :destroy]

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

  resources :searches, only: [:index]

  resources :event_types do
    resources :event_descriptors, only: :index, on: :member
  end

  resources :inappropriate_contents, only: [] do
    put :fix, on: :member
  end
end
