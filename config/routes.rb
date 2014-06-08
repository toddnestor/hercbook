Rails.application.routes.draw do
  resources :activities, only: [:index]

  get 'members/list'

  get 'members/search'

  as :user do 
    get '/register', to: 'devise/registrations#new', as: :register
    get '/login', to: 'devise/sessions#new', as: :login
    get '/logout', to: 'devise/sessions#destroy', as: :logout
  end

  devise_for :users, skip: [:sessions]

  as :user do
    get "/login" => 'devise/sessions#new', as: :new_user_session
    post "/login" => 'devise/sessions#create', as: :user_session
    delete "/logout" => 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :user_friendships do
    member do
      post :accept
      get :accept
      put :block
      get "/destroy" => "user_friendships#destroy"
      post "/destroy" => "user_friendships#destroy"
    end
  end

  resources :statuses

  get 'feed', to: 'statuses#index', as: :feed
  get 'feed/create', to: 'statuses#new', as: :feed_create

  root to: 'activities#index'

  
  scope ":profile_name" do
    resources :albums do
      resources :pictures
    end
  end

  get '/:id', to: 'profiles#show', as: 'profile'


end
