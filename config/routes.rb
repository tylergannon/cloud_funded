CloudFunded::Application.routes.draw do

  namespace :open_graph do 
    resources :actions do
      collection do
        get :follow
      end
    end
  end

  # Static Pages
  match '/how-it-works' => 'static_pages#how_it_works', as: :how_it_works
  match '/about' => 'pages#show', id: 'about'

  namespace :projects do resources :roles end

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
      member { 
        put :mercury_update 
        post :publish
      }
      resources :attachments
    end
    namespace :projects do
      resources :categories
    end
    resources :projects
    resources :test
  end

  resource :my_account, as: 'account', only: [:show, :edit, :update], controller: 'accounts' do
    member do 
      put :send_reset_password_instructions, as: :send_reset_password_instructions
      get :dwolla_auth_failure
    end
    resources :funds, path_names: {:new => 'add'}, controller: 'members/transactions'
  end
  
  resources :profiles
  resource :profile, path_names: {edit: :settings}
    
  namespace :projects do
    resources :categories
  end
  

  resources :projects, path_names: {edit: :settings, :new => :fund_yours} do
    member do 
      put :mercury_update
      get :sharing
    end
    resource :facebook_action
    resources :attachments, controller: 'admin/attachments'
    resource :my_pledge, controller: :pledges
    resources :pledges
    resources :team, as: :roles, controller: 'projects/roles' do
      member {get :confirm}
    end
    resources :updates, controller: 'projects/articles', path_names: {:new => :new, :edit => :edit} do
      member { 
        post :publish 
        put :mercury_update
      }
    end
    resources :transactions, controller: 'projects/transactions', path_names: {
      :new => :new, :edit => :edit
    }
    resources :perks, controller: 'projects/perks' do
      collection do
        post :sort
      end
    end
  end
  
  match '/members/auth/dwolla/callback' => 'accounts#dwolla_auth_failure' , constraints: {query_string: "access_denied&error_description=The+user+denied+the+request."}
    
  devise_for :members, controllers: {
    omniauth_callbacks: 'members/omniauth_callbacks',
    registrations: 'members/registrations',
    sessions: 'members/sessions'
  }
  
  match '/blog' => 'articles#index', as: :blog
  match '/blog/:id' => 'articles#show', as: :blog_post
  match '/admin' => 'admin/controls#index'
  match '/feedback' => 'feedbacks#new', as: :submit_feedback
  match '/feedback_received' => 'feedbacks#index', as: :feedback_received
  match '/my_projects' => 'projects#index', defaults: {show: "mine"}, as: :my_projects
  match '/member_search(.:format)' => 'accounts#search', as: :member_search
  
  match '/get_funded(/:id)' => 'projects/wizard#show', as: :get_funded, via: 'get'
  match '/get_funded(/:id)' => 'projects/wizard#update', via: 'put'
  
  match '/projects/:project_id/wizard(/:id)' => 'projects/wizard#show', as: :project_wizard, via: 'get'
  match '/projects/:project_id/wizard(/:id)' => 'projects/wizard#update', via: 'put'
  
  # resource :get_funded, controller: 'projects/wizard', as: :get_funded
  
  as :member do
    get '/my_account/change_password' => 'members/registrations#edit',  as: :change_password
  end
  
  # match '/projects/:project_id/my_pledge/edit' => 'pledges#edit', as: :edit_my_pledge
  # match '/projects/:project_id/my_pledge' => 'pledges#show', as: :my_pledge
  match '/:id/comments' => 'projects#show', as: :project, defaults: {show: 'comments'}, via: 'get'
  match '/:id/team' => 'projects#show', as: :project, defaults: {show: 'team'}, via: 'get'
  match '/:id/updates' => 'projects#show', as: :project, defaults: {show: 'updates'}, via: 'get'
  match '/:id/pledges' => 'projects#show', as: :project, defaults: {show: 'pledges'}, via: 'get'
  match '/:id/info' => 'projects#show', as: :project, defaults: {show: 'info'}, via: 'get'
  match '/:id(.:format)' => 'projects#show', as: :project, :constraints => { :format => /(json|html)/ }, via: 'get'
  match '/:id(.:format)' => 'projects#update', as: :project, :constraints => { :format => /(json|html)/ }, via: 'post'

  match '/:project_id/pledge(/:id)' => 'projects/pledge_wizard#show', as: :new_project_pledge, via: 'get'
  match '/:project_id/pledge(/:id)' => 'projects/pledge_wizard#update', via: 'put'
  match '/:project_id/my_pledge(.:format)' => 'pledges#show', via: 'get', as: :project_my_pledge

  match '/projects/:project_id/perks/:id(.:format)' => 'projects/perks#update', via: :post

  root to: 'projects#index'
end
