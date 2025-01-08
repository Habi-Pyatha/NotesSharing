Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      post "users/sign_in", to: "sessions#create"
      delete "users/sign_out", to: "sessions#destroy"
      resources :notes, only: [ :index ]
    end
  end
   
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "notes#index"
  resources :notes, only: [ :index, :create, :edit, :new, :update, :destroy, :show ] do
    post :remove_add_form, on: :collection
    post :remove_content, on: :collection
    # collection do
    #   post :remove_add_form
    #   post :remove_content
    # end
  end
  resources :friendships, only: [ :index, :create, :update, :destroy ] do
    member do
      post :send_friend_request
      post :accept
      post :reject
      delete :remove_friend
    end

    collection do
      get :pending_requests
    end
  end
end
