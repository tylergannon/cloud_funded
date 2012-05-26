CloudFunded::Application.routes.draw do

  Mercury::Engine.routes

  resources :articles, only: [:index, :show]
  namespace :admin do
    resources :articles do
      member { post :mercury_update }
      resources :attachments
    end
  end

  resources :profiles
  resource :profile
  
  resources :projects do
    resources :pledges
  end
  devise_for :members, controllers: {
    omniauth_callbacks: 'members/omniauth_callbacks',
    registrations: 'members/registrations'
  }
  
  match '/blog' => 'articles#index'
  
  root to: 'projects#index'
end
