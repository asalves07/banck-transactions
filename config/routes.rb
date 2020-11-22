Rails.application.routes.draw do
  devise_for :users

  get "/statement" => "bank_statements#statement"
  get "/deposit" => "bank_statements#deposit"
  get "/extract" => "bank_statements#extract"
  get "/transfer" => "bank_statements#transfer"
  get "/new" => "bank_statements#new"


  get "/shut" => "accounts#shut"
  resources :accounts, only:[:index]

  get 'welcome/index'
  root to: 'welcome#index'

end
