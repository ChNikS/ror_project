# config valid only for current version of Capistrano
lock '3.6.1'

set :application, 'ror_project'
set :repo_url, 'https://github.com/ChNikS/ror_project.git'

set :deploy_to, '/home/deployer/ror_project'
set :deploy_user, 'deployer'

append :linked_files, 'config/database.yml', 'config/secrets.yml', 'config/private_pub.yml', 'config/private_pub_thin.yml', '.env'

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'public/uploads'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # execute :touch, release_path.join('tmp/restart.txt')
      invoke 'unicorn:restart'
    end
  end

  after :publishing, :restart
end