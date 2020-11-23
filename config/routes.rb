Rails.application.routes.draw do
  devise_for :users

  get "/new_deposit" => "bank_statements#new_deposit"
  get "/new_extract" => "bank_statements#new_extract"
  get "/in_transfer" => "bank_statements#new_transfer"
  get "/ex_transfer" => "bank_statements#ex_transfer"
  get "/statement" => "bank_statements#statement"
  post "/deposit" => "bank_statements#deposit"
  post "/extract" => "bank_statements#extract"
  post "/transfer" => "bank_statements#transfer"


  resources :accounts, only:[:index, :create, :update]
  get "/shut_down" => "accounts#shut_down"
  resources :users, only:[:edit, :update]

  get 'welcome/index'
  root to: 'accounts#index'

end
