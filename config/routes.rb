# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  devise_for :users, path: '', path_names: {
                                 sign_in: 'login',
                                 sign_out: 'logout',
                                 registration: 'signup'
                               },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations'
                     }

  namespace :api do
    namespace :v1 do
      post 'google_auth', to: 'google_auth#authenticate'
      resources :bids, except: %i[destroy]
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
