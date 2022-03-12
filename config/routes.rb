Rails.application.routes.draw do
  
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    sessions: 'users/sessions', registrations: 'users/registrations', confirmations: 'users/confirmations', 
    passwords: 'users/passwords', unlocks: 'users/unlocks'
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  resources :hosts
  
  resources :pages, only: [:index] do
    collection do 
      post 'export_my_data'
    end
  end
  
  root to: "pages#index"
end
