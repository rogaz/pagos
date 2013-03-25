Pagos::Application.routes.draw do
  resource  :user_session, :only => [:new, :create, :destroy]

  delete 'logout' => 'user_sessions#destroy', :as => :logout

  match 'sign_in' => 'User_sessions#new', :as => 'signin'

  resources :users

  resources :student_payments
  get 'student_payment/:id/download' => 'student_payments#download'

  resources :patient_payments
  get 'patient_payment/:id/download' => 'patient_payments#download'

  root :to => 'Categories#index'

  post 'pay_patient_charge/:patient_charge_id' => 'patient_charges#pay_patient_charge', :as => :pay_patient_charge

  resources :patient_charges
  get 'patient_charge/:id/download' => 'patient_charges#download'

  post 'pay_student_charge/:student_charge_id' => 'student_charges#pay_student_charge', :as => :pay_student_charge

  put 'people/apply_surcharge/:student_charge_id' => 'student_charges#apply_surcharge', :as => :apply_surcharge
  put 'people/no_apply_surcharge/:student_charge_id' => 'student_charges#no_apply_surcharge', :as => :no_apply_surcharge

  resources :student_charges
  get 'student_charge/:id/download' => 'student_charges#download'

  resources :patients

  resources :students

  get 'people/:id/charges/' => 'people#charges', :as => :people_charges
  get 'people/:id/charges_by_month' => 'people#charges_by_month', :as => :people_charges_by_month
  resources :people

  resources :categories

  get 'student_charges/:category_id/information/' => 'student_charges#index', :as => :information_student_charges
  get 'patient_charges/:category_id/information/' => 'patient_charges#index', :as => :information_patient_charges

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
  # match ':controller(/:action(/:id))(.:format)'
end
