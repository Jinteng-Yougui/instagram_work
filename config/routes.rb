Rails.application.routes.draw do
  get 'sessions/new'
  resources :sessions, only: [:new, :create, :destroy]
  resources :users, only: [:new]
  resources :pictures do
    collection do
      post :confirm
    end
  end
end
