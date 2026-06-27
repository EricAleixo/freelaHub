Rails.application.routes.draw do
  resources :posts

  root "dashboard#show"
  
  resources :proposals
  resources :jobs
  resources :profile_skills
  resources :skills
  
  
  get "profile/edit",      to: "profiles#edit",   as: :edit_profile  # primeiro
  get "profile/:username", to: "profiles#show",   as: :profile
  patch "profile",         to: "profiles#update"
  put   "profile",         to: "profiles#update"

  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
