require 'data_mapper' # metagem, requires common plugins too.

# datamapper 로그 찍기
DataMapper::Logger.new($stdout, :debug)
# need install dm-sqlite-adapter
configure :development do
    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
end

configure :production do 
    DataMapper::setup(:default, ENV["DATABASE_URL"]) 
end

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end
class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :email, String
  property :password, String
  property :created_at, DateTime
end
# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!
User.auto_upgrade!