Rails.application.routes.draw do
  root to: "creators#new"
  resources :creators
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
