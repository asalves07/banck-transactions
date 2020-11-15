Rails.application.routes.draw do
  devise_for :users


  get "/accounts/index" => "accounts#index" 
  

end
