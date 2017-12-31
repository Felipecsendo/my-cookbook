Rails.application.routes.draw do
  root to: 'home#index'
  resources :cuisines, only: [:new, :show, :create]
  resources :recipes, only: [:new, :show, :create, :edit, :update]
  resources :recipe_types, only: [:new, :show, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
