gem 'json', '~> 1.6'
require 'sinatra'
require 'sinatra/reloader'
require 'data_mapper' # metagem, requires common plugins too.

# datamapper 로그 찍기
DataMapper::Logger.new($stdout, :debug)
# need install dm-sqlite-adapter
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Post
  include DataMapper::Resource
  property :id, Serial
  property :title, String
  property :body, Text
  property :created_at, DateTime
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Post.auto_upgrade!

before do 
  p '***************************'
  p params
  p '***************************'
end
get '/' do # routing, '/' 경로로 들어왔을 때
 send_file 'index.html' # index.html 파일을 보내줘
end

get '/lunch' do # '/lunch' 경로로 들어왔을 때
  @lunch = ["멀캠20층", "바스버거", "소고기"]
  erb :lunch # views폴더 안에 있는 lunch.erb를 보여줘
end

# 게시글을 모두 보여주는 곳
get '/posts' do
  @posts = Post.all.reverse
  @posts = Post.all(order=> [:id.desc])
  erb :'posts/posts'
end

# 게시글을 쓸 수 있는 곳
get '/posts/new' do
  erb :'posts/new'
end

get '/posts/create' do
  @title = params[:title]
  @body = params[:body]
  Post.create(title: @title, body: @body)
  erb :'posts/create'
end