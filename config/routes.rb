Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  resources :cuisines, only: [:new, :show, :create]
  resources :recipes, only: [:new, :show, :create, :edit, :update, :destroy] do
    collection do
      get 'search'
      get 'list'
      get 'my_favorites'
    end
    member do
      post 'favorite'
      delete 'destroy_favorite'
      post 'share'
    end
  end

  resources :recipe_types, only: [:new, :show, :create]

end
