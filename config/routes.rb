Agreatfirstdate::Application.routes.draw do
  
  resources :profiles, :only => [:show]
  get '/me'      => 'profiles#me',      :as => :my_profile
  get '/me/edit' => 'profiles#edit',    :as => :edit_profile
  put '/me/edit' => 'profiles#update',  :as => :update_profile
  
  post '/me/add_avatar'     => 'profiles#add_avatar',     :as => :add_avatar
  post '/me/select_pillars' => 'profiles#select_pillars', :as => :select_pillars
  post '/me/add_event'   => 'profiles#add_event', :as => :add_event
  
  post '/second_step' => 'users#store_settings', :as => :store_settings
  
  devise_for :users, :controllers => { :registrations => "registrations" }

  get "welcome/index"
  get "welcome/about"
  get "welcome/blog"
  get "welcome/faq"
  get "welcome/privacy"
  get "welcome/terms"

  resources :pillars do
    resources :event_types, only: :index, on: :member do
      resources :event_descriptors, only: :index, on: :member
    end
    resources :event_items, only: [:index, :create, :update], on: :member
  end
  resources :event_items
  resources :event_photos

  resources :event_types do
    resources :event_descriptors, only: :index, on: :member
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

