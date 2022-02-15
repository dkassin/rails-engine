Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants do
        get :find_all, on: :collection, controller: :searches
        resources :items, only: [:index], controller: :merchant_items
      end
      resources :items do
        get :find, on: :collection, controller: :searches
        resources :merchant, only: [:index], controller: :item_merchants
      end

      namespace :revenue do
        resources :merchants, only: [:index, :show]
      end
    end
  end
end
