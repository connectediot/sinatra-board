require 'sinatra'
require 'sinatra/reloader'
require './model.rb'

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
  @posts = Post.all
  # @posts = Post.all(order=> [:id.desc])
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

# CRUD - Read
# variable routing
# 을 통해서 특정한 게시글을 가져온다.
get '/posts/:id' do
  # 게시글 id를 받아서
  @id = params[:id]
  # db에서 찾는다.
  @post = Post.get(@id)
  erb :'posts/show'
end

get '/posts/destroy/:id' do
  Post.get(params[:id]).destroy
  # erb :'posts/destroy'
  redirect '/posts'
end

# 값을 받아서 뿌려주기 위한 용도
get '/posts/edit/:id' do
  @id = params[:id]
  @post = Post.get(@id)
  erb :'posts/edit'
end

get '/posts/update/:id' do
  @id = params[:id]
  Post.get(@id).update(title: params[:title], body: params[:body])
  redirect '/posts/'+@id
end