Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/api/v1/albums", to: "albums#index", as: "albums"
  get "/api/v1/artists", to: "artists#index", as: "artists"
  get "/api/v1/songs", to: "songs#index", as: "songs"
  get "/api/v1/users", to: "users#index", as: "users"
  get "/api/v1/reviews", to: "album_reviews#index", as: "reviews"

  post '/api/v1/artists', to: "artists#create"
  post '/api/v1/albums', to: "albums#create"
  post '/api/v1/songs', to: "songs#create"
  post '/api/v1/users', to: "users#create"

  post '/api/v1/users/:id/reviews', to: "album_reviews#create"


end
