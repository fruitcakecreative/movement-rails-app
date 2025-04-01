Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  namespace :api do
    resources :events
    resources :venues, only: [:index, :show]
    resources :artists, only: [:index, :show]
    resources :genres, only: [:index]
    resources :users, only: [:show, :update]
    resources :event_attendees, only: [:create, :destroy]
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  
  if Rails.env.production?
    get "/run-seed" => proc {
      Rails.application.load_seed
      [200, {}, ["Seed complete"]]
    }
  end
end
