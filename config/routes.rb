Rails.application.routes.draw do
  get 'sessions/new'

  get 'users/new'

  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'class_list' => 'static_pages#class_list'
  get 'help' => 'static_pages#help'
  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  get 'previous_class' => 'static_pages#previous_class'
  get 'drop_add' => 'static_pages#drop_add'
  get 'finaid' => 'static_pages#finaid'
  get 'grades' => 'static_pages#grades'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'static_pages#home/refresh/:user_id' => 'static_pages#refresh_action', as: :refresh_action
  get 'class_list/refresh' => 'static_pages#refresh_classlist_action', as: :refresh_classlist_action
  get 'class_list/delete' => 'static_pages#delete_action', as: :delete_classlist_action
  resources :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
