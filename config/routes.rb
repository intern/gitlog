Gitlog::Application.routes.draw do

  resource :account,
           :controller => 'users',
           :except => [ :show ],
           :path_names => {
             :new => 'signup',
             :edit => 'settings'
           } do
    get :show
  end

  controller :user_sessions do
    get   :login, :to => :new, :as => 'login'
    post  :login, :to => :create, :as => 'login'

    match :logout, :to => :destroy, :as => 'logout'

    get   :retrieve_password, :to => :new_retrieve_password
    post  :retrieve_password, :to => :create_retrieve_password
  end
  #get "login",    :to => 'user_sessions#new',     :as => 'login'

  #post "login",   :to => 'user_sessions#create',  :as => 'login_post'

  #match "logout", :to => 'user_sessions#destroy', :as => 'logout'
  match "account/activate/:token", :to => 'users#activate', :as => 'account_activate'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  # match '/account/logout' => 'user_sessions#destory', :as => :logout

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
  # root :to => "welcome#index"
  root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
