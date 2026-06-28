Rails.application.routes.draw do
  resources :posts
  root "dashboard#show"
  resources :proposals
  resources :profile_skills
  resources :skills
  get "profile/edit",      to: "profiles#edit",   as: :edit_profile
  get "profile/:username", to: "profiles#show",   as: :profile
  patch "profile", to: "profiles#update", as: :update_profile
  put   "profile", to: "profiles#update"

  resources :jobs do
    collection do
      get :my_jobs
    end
    resources :proposals, only: [:new, :create] do
      member do
        patch :accept
        patch :reject
      end
    end
  end

  resources :notifications, only: [:index, :destroy]

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  get "up" => "rails/health#show", as: :rails_health_check
end