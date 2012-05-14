CloudFunded::Application.routes.draw do
  resources :projects do
    resources :pledges
  end
  devise_for :members, :controllers => { :omniauth_callbacks => "members/omniauth_callbacks" }
  root to: 'projects#index'
end
