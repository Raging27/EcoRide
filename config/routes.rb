Rails.application.routes.draw do
  get "dashboard/index"
  devise_for :users
  get "home/index"

  resources :trips, only: [ :index, :show, :new, :create ] do
    resources :passenger_bookings, only: [ :create ]
  end

  resources :passenger_bookings, only: [ :destroy ]

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "dashboard", to: "dashboard#index"


  root to: "home#index"
end
