Rails.application.routes.draw do

  get 'users/index'
  get 'users/golfers/:id', to: 'users#golfers', as: :users_golfers
  devise_for :users, :controllers => { :registrations => "registrations" }
  #devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'users#index'

  # Custom Golfer routes (rank and update_rank)
  # get 'golfers/rank', to: 'golfers#rank', as: :golfer_rank 
   post 'golfers/update_rank', to: 'golfers#update_rank', as: :update_golfer_rank

   get 'golfer/clear_scores', to: 'golfers#clear_score', as: :golfers_clear_score
   get 'golfers/manage', to: 'golfers#manage', as: :golfers_manage
   get 'golfers/list', to: 'golfers#list', as: :golfer_list
   get 'golfers/who_has/:id', to: 'golfers#who_has', as: :golfer_who_has
   get 'golfers/manual_score_update', to: 'golfers#manual_score_update', as: :golfer_manual_score_update
   post 'golfers/score_update_manually', to: 'golfers#score_update_manually', as: :golfer_score_update_manually
   get 'golfers/golfer_scores', to: 'golfers#golfer_scores', as: :golfer_scores

   resources :golfers
   get 'selections/golfers', to: 'selections#golfers', as: :selection_golfers
   get 'selections/clear', to: 'selections#clear', as: :selection_clear
   resources :selections
   get 'tournaments/activate/:id', to: 'tournaments#activate', as: :tournament_activate
   resources :tournaments

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
