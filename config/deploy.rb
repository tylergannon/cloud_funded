set :application, "CloudFunded"
set :repository,  "git@github.com:tylergannon/cloud_funded.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

server "www.tylergannon.me", :app, :web, :db, :primary => true

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :deploy_to, "/home/tyler/src/dev/cloud_funded"

default_run_options[:pty] = true
require 'bundler/capistrano'
load 'deploy/assets'

# require 'rvm'
require "rvm/capistrano"

set :rvm_ruby_string, '1.9.3'
set :rvm_ruby_gem_set_name, 'passenger'
set :rvm_type, :user  # Don't use system-wide RVM

after "deploy", "deploy:migrate"

task :restart, :roles => [:app], :except => {:no_release => true} do
  run "cd #{deploy_to}/current && touch tmp/restart.txt"
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end