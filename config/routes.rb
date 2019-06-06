BookingsyncPortal::Engine.routes.draw do
  namespace :admin do
    resources :rentals, only: [:index, :show]
    resources :connections, only: [:create, :destroy]
    resources :remote_accounts, only: [:new, :create]
    get 'help', to: 'help#index'
    root to: 'rentals#index'
    namespace :v2 do
      resources :rentals, only: :index
    end
  end
end
