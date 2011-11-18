DashboardRails::Application.routes.draw do
  resources :vertical_spacers

  # Root currently goes to the first Dashboard
  root :to => redirect("/dashboards/1")
  
  # Root shows listing of available dashboards
  #root :controller => "application", :action => "index"
  
  match '/widgets/:id/embed' => 'widgets#embed'
  match '/ganglia_graphs/:id/data' => 'ganglia_graphs#data'
  match '/doc' => redirect("/doc/app/index.html")

  # Routes to show/edit/list resources
  scope :path_names => { :new => "add", :destroy => "remove" } do
    resources :dashboards do
      resources :widgets, :only => :index
    end
    resources :ganglia_graphs, :github_commits, :hudson_build_statuses, :jira_countdowns, :jira_issue_summaries, :sonar_reports, :vertical_spacers
    #resources :dashboard_widgets
	resources :widgets
  end
  
  #match "widgets/:controller"
  
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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
