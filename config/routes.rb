CloudFunded::Application.routes.draw do

  resources :comments

  mount Mercury::Engine => '/'

  resources :feedbacks, only: [:new, :create, :index]
  resources :pages, only: :show
  resources :articles, only: [:index, :show] do
    resources :comments
  end
  
  namespace :admin do
    resources :members, path_names: {edit: :chang3_that_sh1t}
    resources :feedbacks
    
    resources :pages do
      member { put :mercury_update }
      resources :attachments
    end
    
    resources :articles do
      member { put :mercury_update }
      resources :attachments
    end
    namespace :projects do
      resources :categories
    end
    resources :projects
  end

  resource :my_account, as: 'account', only: [:show, :edit, :update], controller: 'accounts' do
    resources :funds, path_names: {:new => 'add'}, controller: 'members/transactions'
  end
  
  resources :profiles
  resource :profile, path_names: {edit: :settings}
    
  namespace :projects do
    resources :categories
  end

  resources :projects, path_names: {edit: :settings, :new => :fund_yours} do
    resource :facebook_action
    resource :my_pledge, controller: :pledges
    resources :pledges
    resources :updates, controller: 'projects/articles', path_names: {
      :new => :new, :edit => :edit
    }
    resources :transactions, controller: 'projects/transactions', path_names: {
      :new => :new, :edit => :edit
    }
    resources :perks, controller: 'projects/perks', path_names: {
      :new => :new, :edit => :edit
    }
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
  
  match '/get_funded(/:id)' => 'projects/wizard#show', as: :get_funded, via: 'get'
  match '/get_funded(/:id)' => 'projects/wizard#update', via: 'put'
  match '/projects/:project_id/wizard(/:id)' => 'projects/wizard#show', as: :get_funded, via: 'get', defaults: {id: 'basics'}
  match '/projects/:project_id/wizard(/:id)' => 'projects/wizard#update', via: 'put'
  
  # resource :get_funded, controller: 'projects/wizard', as: :get_funded
  
  as :member do
    get '/my_account/settings' => 'members/registrations#edit',  as: :account_settings
  end
  
  # match '/projects/:project_id/my_pledge/edit' => 'pledges#edit', as: :edit_my_pledge
  # match '/projects/:project_id/my_pledge' => 'pledges#show', as: :my_pledge
  
  match '/:id(.:format)' => 'projects#show', as: :project, :constraints => { :format => /(json|html)/ }, via: 'get'
  match '/:id(.:format)' => 'projects#update', as: :project, :constraints => { :format => /(json|html)/ }, via: 'post'
  match '/projects/:project_id/perks/:id(.:format)' => 'projects/perks#update', via: :post

  root to: 'projects#index'
end
