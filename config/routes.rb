Rails.application.routes.draw do
  get "vehicles/index"
  get "vehicles/new"
  get "vehicles/create"
  get "dashboard/index"
  devise_for :users
  get "home/index"

  resources :trips, only: [ :index, :show, :new, :create ] do
    resources :passenger_bookings, only: [ :create ]
  end

  resources :passenger_bookings, only: [ :destroy ]

  resources :vehicles, only: [ :index, :new, :create ]

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "dashboard", to: "dashboard#index"


  root to: "home#index"
end
