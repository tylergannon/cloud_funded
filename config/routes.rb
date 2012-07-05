CloudFunded::Application.routes.draw do
  get "dwolla/create"

  get "dwolla/show"

  get "new_project/show"

  get "new_project/update"

  resources :comments

  Mercury::Engine.routes

  resources :feedbacks, only: [:new, :create, :index]
  resources :pages, only: :show
  resources :articles, only: [:index, :show] do
    resources :comments
  end
  
  namespace :admin do
    resources :members, path_names: {edit: :chang3_that_sh1t}
    resources :feedbacks
    
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
  resource :profile, path_names: {edit: :settings} do
    
  end
  
  resources :projects, path_names: {edit: :settings, :new => :fund_yours} do
    resource :facebook_action
    resource :my_pledge, controller: :pledges
    resource :wizard, controller: :after_create_project
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
  match '/projects/:project_id/pledge' => 'pledges#new', as: :new_project_pledge
  match '/my_projects' => 'projects#index', defaults: {show: "mine"}, as: :my_projects
  # match '/projects/:project_id/my_pledge/edit' => 'pledges#edit', as: :edit_my_pledge
  # match '/projects/:project_id/my_pledge' => 'pledges#show', as: :my_pledge
  root to: 'projects#index'
end
