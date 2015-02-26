BookingsyncPortal::Engine.routes.draw do
  namespace :admin do
    resources :rentals, only: [:index, :show] do
      put :disconnect, on: :member
      put :connect, on: :member
    end
    resources :remote_accounts, only: [:new, :create]
    root to: 'rentals#index'
  end

  namespace :admin_api do
    # FIXME properly handle cuurent account resource
    # jsonapi_resource :account
    jsonapi_resources :remote_accounts
    jsonapi_resources :rentals, only: [:index, :show]
    jsonapi_resources :remote_rentals, only: [:index, :show]
    jsonapi_resources :connections
  end
end
