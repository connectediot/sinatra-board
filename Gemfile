source 'https://rubygems.org'
gem 'sinatra'
gem 'sinatra-reloader'
gem 'datamapper'
gem 'json', '~> 1.6'
gem 'bcrypt'

group :production do
    gem 'pg'
    gem 'dm-postgres-adapter'
end

group :development, :test do
    gem 'dm-sqlite-adapter'    
end