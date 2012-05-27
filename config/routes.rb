CloudFunded::Application.routes.draw do
  Mercury::Engine.routes

  resources :feedbacks, only: [:new, :create, :index]
  resources :pages, only: :show
  resources :articles, only: [:index, :show]
  
  namespace :admin do
    resources :members, :feedbacks
    
    resources :pages do
      member { post :mercury_update }
      resources :attachments
    end
    
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
  
  match '/blog' => 'articles#index', as: :blog
  match '/blog/:id' => 'articles#show', as: :blog_post
  match '/admin' => 'admin/controls#index'
  match '/feedback' => 'feedbacks#new', as: :submit_feedback
  match '/feedback_received' => 'feedbacks#index', as: :feedback_received
  root to: 'projects#index'
end
