Ruvote::Application.routes.draw do


  resources :screens, :only => [:show, :update] do
    member do
      get "banner"
      get "twitts"
      get "question"
      get "statistics"
    end
  end

  get "home" => 'static#home'
  get 'login/registration' => 'login#registration'
  get 'login/forgot_password' => 'login#forgot_password'
  get 'login/login' => 'login#login'

  resources :s, :only => [:show, :index] do
    member do 
      get 'twitt'
      get 'name'
      post 'set_name'
    end
  end

  resources :votes, :only => [] do
    collection do
      post 'radio'
      post 'check'
    end
  end

  resources :twitts, :only => [:create, :destroy]

  resources :answer_variants, :only => [:show, :edit, :create, :update, :destroy] do
    member do
      post 'bringup'
      post 'bringdown'
    end
  end

  resources :questions, :only => [:show, :edit, :create, :update, :destroy] do
    resources :answer_variants, :only => [:new]
    member do
      post "switch_state"
      post "reset_state"
    end
  end

  resources :sections, :only => [:show, :edit, :create, :update, :destroy] do
    resources :questions, :only => [:new]
    resource :section_statistics, :only => [:show]
    member do
      get 'twitts_edit'
      get 'twitts'
    end
    collection do
      post '/twitt/:twitt_id/activate' => 'sections#activate_twitt'
    end
  end

  resources :meetings do
    resources :sections, :only => [:new]
  end

  devise_for :users

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
  root :to => "static#home"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
