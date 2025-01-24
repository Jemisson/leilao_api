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

  namespace :api do
    namespace :v1 do
      resources :bids, except: %i[destroy]
      resources :categories
      resources :profile_users
      resources :products do
        delete 'images/:image_id', to: 'products#destroy_image', as: 'destroy_image'
      end
    end
  end
end
