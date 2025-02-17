Rails.application.routes.draw do
  get "static_pages/contact"
  get "static_pages/mentions_legales"
  devise_for :users

  get "home/index"

  get "dashboard", to: "dashboard#index", as: :dashboard

  get "contact", to: "static_pages#contact"
  get "mentions-legales", to: "static_pages#mentions_legales"


  resources :trips, only: [ :index, :show, :new, :create ] do
    resources :passenger_bookings, only: [ :create ]
  end

  resources :passenger_bookings, only: [ :destroy ]

  resources :vehicles, only: [ :index, :new, :create ]

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root to: "home#index"
end
