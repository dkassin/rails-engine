Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # get "/merchants/find_all", to: 'searches#find_all'
      # get "/items/find", to: 'searches#find'
      resources :merchants do
        get :find_all, on: :collection, controller: :searches
        resources :items, only: [:index], controller: :merchant_items
      end
      resources :items do
        get :find, on: :collection, controller: :searches
        resources :merchant, only: [:index], controller: :item_merchants
      end
    end
  end
end
