BookingsyncPortal::Engine.routes.draw do
  namespace :admin do
    resource :home, only: :show, controller: :home
    resources :rentals, only: [:index, :show] do
      put :disconnect, on: :member
      put :connect, on: :member
    end

    resources :remote_accounts, only: [:new, :create]

    resources :remote_rentals, only: :index
    resources :connections, only: [:create, :destroy]
    root to: 'home#show'
  end
end
