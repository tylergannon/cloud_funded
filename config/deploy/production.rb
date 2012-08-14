set :deploy_to, '/home/tyler/src/prod/cloud_funded'
set :branch, 'master'
set :rails_env, 'production'
load 'deploy/assets'

# namespace :deploy do
#   namespace :assets do
#     task :precompile, :roles => :web, :except => { :no_release => true } do
#       from = source.next_revision(current_revision)
#       if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
#         run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
#       else
#         logger.info "Skipping asset pre-compilation because there were no asset changes"
#       end
#     end
#   end
# end