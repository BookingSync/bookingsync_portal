BookingsyncPortal::Engine.routes.draw do
  namespace :admin do
    resources :rentals, only: [:index, :show] do
      put :disconnect, on: :member
      put :connect, on: :member
    end
    resources :remote_accounts, only: [:new, :create]
    get 'help', to: 'help#index'
    root to: 'rentals#index'
  end
end
