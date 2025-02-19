Rails.application.routes.draw do
  # Devise routes for users
  devise_for :users

  # Static pages
  get "contact", to: "static_pages#contact"
  get "mentions-legales", to: "static_pages#mentions_legales"

  # Home page
  get "home/index"

  # Dashboard
  get "dashboard", to: "dashboard#index", as: :dashboard
  get "dashboard/edit", to: "dashboard#edit", as: :edit_dashboard
  patch "dashboard", to: "dashboard#update"

  # Trips and nested Passenger Bookings
  resources :trips, only: [ :index, :show, :new, :create ] do
    member do
      patch "start"
      patch "finish"
    end
    resources :passenger_bookings, only: [ :create ]
  end

  # Passenger Bookings (for deletion)
  resources :passenger_bookings, only: [ :destroy ]

  # Vehicles
  resources :vehicles, only: [ :index, :new, :create, :edit, :update ]

  # Health and PWA endpoints
  get "up", to: "rails/health#show", as: :rails_health_check
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # Root path
  root to: "home#index"
end
