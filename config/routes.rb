Rails.application.routes.draw do

  # =========================
  # ROOT
  # =========================
  root "home#index"


  # =========================
  # HTML ROUTES
  # =========================

mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :users do
    collection do
      get :login
      post :login, action: :login_create
    end
     resources :products
    resource :profile
    resources :addresses
    resources :orders
    resources :carts
    resources :wishlists
  end

  resources :products do
    member do
      post :add_to_cart
      post :add_to_wishlist
      post :quick_order
    end

    resources :reviews
  end

  resources :categories
  resources :brands
  resources :suppliers

  resources :orders do
    collection do
      post :place_from_cart
    end

    resources :order_items
    resources :payments
    resources :shipments
  end

  resources :carts do
    resources :cart_items
  end

  resources :wishlists do
    resources :wishlist_items
  end

  resources :coupons
  resources :notifications
  resources :messages
  resources :inventories


  # =========================
  # API ROUTES (VERSIONED)
  # =========================

  namespace :api do
    namespace :v1 do

      resources :users
      resources :products
      resources :orders
      resources :payments
      resources :brands
      resources :suppliers
      resources :shipments
      resources :coupons
      resources :notifications
      resources :messages
      resources :addresses
      resources :reviews
      resources :wishlists
      resources :wishlist_items
      resources :carts
      resources :cart_items
      resources :inventories

    end
  end

end
