set :main_server,       "na.fakkelbrigade.eu"
set :user,              'arie'

server "#{main_server}", :web, :app, :db, :primary => true
