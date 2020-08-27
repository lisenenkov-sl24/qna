# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "qna"
set :repo_url, "git@github.com:lisenenkov-sl24/qna.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/qna"

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/master.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system', 'storage'

set :sidekiq_service_unit_user, :system
