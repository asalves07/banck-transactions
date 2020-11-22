Rails.application.routes.draw do
  devise_for :users

  resources :bank_statements, only:[:index, :new]
  get "/statement" => "bank_statements#statement"
  get "/deposit" => "bank_statements#deposit"
  post "/extract" => "bank_statements#extract"
  post "/transfer" => "bank_statements#transfer"


  resources :accounts, only:[:index, :create, :update]

  get 'welcome/index'
  root to: 'welcome#index'

end
