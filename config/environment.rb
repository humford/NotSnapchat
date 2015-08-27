require "bundler"

Bundler.require

configure :development do
  set :database, "sqlite3:db/database.db"
end
# ActiveRecord::Base.establish_connection(
# 	:adapter => "postgresql",
# 	:host => "192.168.59.103",
# 	:username => "root",
# 	:database => "snapchat"
# )
