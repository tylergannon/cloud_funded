CloudFunded::Application.routes.draw do
  resources :profiles, only: [:index, :show]
  resource :profile
  
  resources :projects do
    resources :pledges
  end
  devise_for :members, controllers: {
    omniauth_callbacks: 'members/omniauth_callbacks',
    registrations: 'members/registrations'
  }
  root to: 'projects#index'
end
