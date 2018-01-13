Didact::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :ols, :path => '/o', :except=>:destroy
  
  match 'o/:id/learn/:page' => 'ols#quiz', :via => :put
  match 'o/:id/learn/:page' => 'ols#learn', :via => :get
  match 'o/:id/testall' => 'ols#testall', :via => :get
  match 'o/:id/quizall' => 'ols#quizall', :via => :put
  match 'o/:id/improve' => 'ols#improve', :via => :get
  match 'o/:id/revise' => 'ols#revise', :via => :get
  match 'o/:id/quizimprove' => 'ols#quizimprove', :via => :put

  resources :uls, :path => '/u', :except=>:destroy
    
  match 'u/:id/learn/:page' => 'uls#quiz', :via => :put
  match 'u/:id/learn/:page' => 'uls#learn', :via => :get
  match 'u/:id/testall' => 'uls#testall', :via => :get
  match 'u/:id/quizall' => 'uls#quizall', :via => :put
  match 'u/:id/improve' => 'uls#improve', :via => :get
  match 'u/:id/revise' => 'uls#revise', :via => :get
  match 'u/:id/quizimprove' => 'uls#quizimprove', :via => :put
  
  resources :t2ts, :path => '/tt', :except=>:destroy
    
  match 'tt/:id/learn/:page' => 't2ts#quiz', :via => :put
  match 'tt/:id/learn/:page' => 't2ts#learn', :via => :get
  match 'tt/:id/testall' => 't2ts#testall', :via => :get
  match 'tt/:id/quizall' => 't2ts#quizall', :via => :put
  match 'tt/:id/improve' => 't2ts#improve', :via => :get
  match 'tt/:id/revise' => 't2ts#revise', :via => :get
  match 'tt/:id/quizimprove' => 't2ts#quizimprove', :via => :put
  
  resources :i2ts, :path => '/it', :except=>:destroy
    
  match 'it/:id/learn/:page' => 'i2ts#quiz', :via => :put
  match 'it/:id/learn/:page' => 'i2ts#learn', :via => :get
  match 'it/:id/testall' => 'i2ts#testall', :via => :get
  match 'it/:id/quizall' => 'i2ts#quizall', :via => :put
  match 'it/:id/improve' => 'i2ts#improve', :via => :get
  match 'it/:id/revise' => 'i2ts#revise', :via => :get
  match 'it/:id/quizimprove' => 'i2ts#quizimprove', :via => :put
  
  root :to => 'home#index'
  
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
