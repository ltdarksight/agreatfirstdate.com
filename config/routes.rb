Agreatfirstdate::Application.routes.draw do
  post '/stripe' => 'stripe#web_hook', as: :stripe_web_hook

  resources :profiles, :only => [:show] do
    post 'send_email', on: :member
    put 'activate', on: :member
    put 'deactivate', on: :member
    put 'still_inappropriate', on: :member
    put 'facebook_albums', on: :member
  end

  get '/me'                 => 'my_profile#show',           :as => :my_profile
  get '/me/points'          => 'my_profile#points',         :as => :my_points
  get '/me/edit'            => 'my_profile#edit',           :as => :edit_profile
  get '/me/geo'             => 'my_profile#geo',            :as => :geo_profile
  put '/me'                 => 'my_profile#update',         :as => :update_profile
  put '/me/billing'         => 'my_profile#update_billing', :as => :update_billing
  post '/me/select_pillars' => 'my_profile#select_pillars', :as => :select_pillars

  devise_for :users, :controllers => { :registrations => "registrations", :omniauth_callbacks => "omniauth_callbacks"}
  devise_scope :user do
    get '/users/auth/:provider' => 'omniauth_callbacks#passthru'
  end
  post '/store_settings' => 'users#store_settings', :as => :store_settings

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
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
