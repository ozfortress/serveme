require './config/boot'
require 'puma/capistrano'
require "./config/deploy/logdaemon"

set :stages,            %w(au)
set :default_stage,     "au"
set :application,       "serveme"
set :use_sudo,          false
set :main_server,       "ozfortress.com"
set :keep_releases,     10
set :deploy_via,        :remote_cache
set :repository,        "https://github.com/ozfortress/serveme.git"
set :branch,            'master'
set :scm,               :git
set :copy_compression,  :gzip
set :use_sudo,          false
set :user,              'serveme'
set :rvm_ruby_string,   '2.2.0'
set :rvm_type,          :system
set :stage,             'production'
set :maintenance_template_path, 'app/views/pages/maintenance.html.erb'
set :sidekiq_options, "-c 10"
set :deploy_to,         "/home/serveme/deployed"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after 'deploy:finalize_update', 'app:symlink'
after 'deploy',                 'deploy:cleanup'
after "deploy:stop",            "logdaemon:stop"
after "deploy:start",           "logdaemon:start"
after "deploy:restart",         "logdaemon:restart"

namespace :app do
  desc "makes a symbolic link to the shared files"
  task :symlink, :roles => [:web, :app] do
    run "ln -sf #{shared_path}/config/puma/production.rb #{release_path}/config/puma/production.rb"
    run "ln -sf #{shared_path}/config/initializers/steam_api_key.rb #{release_path}/config/initializers/steam_api_key.rb"
    run "ln -sf #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -sf #{shared_path}/config/paypal.yml #{release_path}/config/paypal.yml"
    run "ln -sf #{shared_path}/public/uploads #{release_path}/public/uploads"
    run "ln -sf #{shared_path}/server_logs #{release_path}/server_logs"
    run "ln -sf #{shared_path}/config/initializers/raven.rb #{release_path}/config/initializers/raven.rb"
    run "ln -sf #{shared_path}/config/initializers/logs_tf_api_key.rb #{release_path}/config/initializers/logs_tf_api_key.rb"
    run "ln -sf #{shared_path}/config/initializers/maps_dir.rb #{release_path}/config/initializers/maps_dir.rb"
    run "ln -sf #{shared_path}/config/initializers/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
    run "ln -sf #{shared_path}/config/initializers/locale.rb #{release_path}/config/initializers/locale.rb"
    run "ln -sf #{shared_path}/config/initializers/devise.rb #{release_path}/config/initializers/devise.rb"
    run "ln -sf #{shared_path}/config/initializers/site_url.rb #{release_path}/config/initializers/site_url.rb"
    run "ln -sf #{shared_path}/doc/GeoLiteCity.dat #{release_path}/doc/GeoLiteCity.dat"
    run "ln -sf #{shared_path}/config/cacert.pem #{release_path}/config/cacert.pem"
  end

end



namespace :puma do
    desc 'Restart puma'
    task :restart, :roles => lambda { puma_role }, :on_no_matching_servers => :continue do
      phased_restart
    end
end

def execute_rake(task_name, path = release_path)
  run "cd #{path} && bundle exec rake RAILS_ENV=#{rails_env} #{task_name}", :env => {'RAILS_ENV' => rails_env}
end

after "deploy", "deploy:cleanup"

require 'rvm/capistrano'
