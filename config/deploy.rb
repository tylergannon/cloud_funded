set :stages, %w(development staging production)
set :default_stage, "development"
require 'capistrano/ext/multistage'

server "www.tylergannon.me", :app, :web, :db, :primary => true
set :application, "CloudFunded"
set :bundle_without,      [:development, :test, :deployment]
set :keep_releases, 5
set :repository,  "git@github.com:tylergannon/cloud_funded.git"
set :rvm_ruby_gem_set_name, 'passenger'
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user  # Don't use system-wide RVM
set :scm, :git

default_run_options[:pty] = true


after "deploy", "deploy:migrate"
after "deploy:migrate", "deploy:restart"
after "deploy:restart", "deploy:cleanup"

require 'bundler/capistrano'
require "rvm/capistrano"
load 'deploy/assets'

task :restart, :roles => [:app], :except => {:no_release => true} do
  run "cd #{deploy_to}/current && touch tmp/restart.txt"
end
