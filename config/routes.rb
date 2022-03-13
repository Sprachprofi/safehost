Rails.application.routes.draw do
  scope '(:locale)', locale: /en|de|uk|ru|fr|it|es|pt/ do
  
    ActiveAdmin.routes(self) rescue ActiveAdmin::DatabaseHitDuringLoad
    devise_for :users, controllers: {
      sessions: 'users/sessions', registrations: 'users/registrations', confirmations: 'users/confirmations', 
      passwords: 'users/passwords', unlocks: 'users/unlocks'
    }
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
    
    resources :hosts, except: [:index] do
      collection do
        get 'finished_signup'
      end
    end
    
    resources :pages, only: [:index] do
      collection do 
        post 'export_my_data'
      end
    end
    
    get 'verifications/new' => 'verifications#new', as: :new_verification
    get 'verifications/no_phone' => 'verifications#no_phone_verify', as: :no_phone_verify
    post 'verifications/do_id_verify' => 'verifications#do_id_verify', as: :do_id_verify
    post 'verifications/send' => 'verifications#do_send_pin', as: :send_verification
    post 'verifications/check' => 'verifications#check', as: :check_verification
    get 'verifications/review' => 'verifications#review', as: :review_verifications
    match 'verifications/verify_member/:id' => 'verifications#verify_member', as: :verify_member, via: [:get, :post]
    match 'verifications/reject_verification/:id' => 'verifications#reject_verification', as: :reject_verification, via: [:get, :post]
    
    root to: "pages#index"
  
  end
end
