# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'creators#new'
  resources :creators, except: %i[new update edit destroy index]

  resources :boards, except: %i[new update edit index] do
    member do
      get 'mines', to: 'boards#get_mines'
    end
  end

  get 'all_boards', to: 'boards#index'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
