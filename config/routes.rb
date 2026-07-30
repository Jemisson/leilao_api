# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  get 'share/products/:id', to: 'share#product', as: :share_product
  get 'share/products/:id/image', to: 'share#product_image', as: :share_product_image
  get 'compartilhar/produto/:id', to: 'share#product'
  get 'compartilhar/produto/:id/image', to: 'share#product_image'

  namespace :api do
    namespace :v1 do
      post 'google_auth', to: 'google_auth#authenticate'
      patch 'users/password', to: 'users/passwords#update'
      get 'dashboard', to: 'dashboard#index'
      resources :bids, except: %i[destroy]
      resource :catalog_setting, only: %i[show update]
      resources :categories
      resources :profile_users do
        get 'bids', to: 'profile_users#bids_per_user', as: 'bids_user'
      end
      resources :products do
        collection do
          get :search
        end
        member do
          patch :mark_as_sold
        end
        delete 'images/:image_id', to: 'products#destroy_image', as: 'destroy_image'
      end
    end
  end
end
