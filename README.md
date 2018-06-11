### Sinatra 정리

##### 준비사항

필수 gem 설치

`$ gem install sinatra`

`$ gem install sinatra-reloader`

##### 시작 페이지 만들기(routing 설정 및 대응되는 view 설정)

```ruby
# app.rb 
require 'sinatra'
require 'sinatra/reloader'

get '/' do # routing, '/' 경로로 들어왔을 때
   send_file 'index.html' # index.html 파일을 보내줘
end

get '/lunch' do # '/lunch' 경로로 들어왔을 때
    erb :lunch # views폴더 안에 있는 lunch.erb를 보여줘
end
```



##### 폴더 구조 

* app.rb
* views/
  * .erb
  * layout.erb

##### layout.erb

```erb
<html>
    <head>
    </head>
    <body>
        <%= yield %>
    </body>
</html>
```

```ruby
def hello
    puts "hello"
    yield
    puts "bye"
end
# {} : block / 코드 덩어리
hello {puts "takhee"}
# => hello takhee bye
```



##### erb에서 루비 코드 활용하기

```ruby
# app.rb
get '/lunch' do
    @lunch = ["바스버거"]
    erb :lunch
end
```

```erb
<!-- lunch.erb -->
<%= @lunch %>

```

##### params 

1. variable routing

   ```ruby
   #app.rb
   get '/hello/:name' do
   	@name = params[:name]
   	erb :name
   end
   ```

   

2. `form` tag를 통해서 받는 법

   ```html
   <form action="/posts/create">
       제목 : <input name="title">
   </form>
   ```

   ```ruby
   # app.rb
   # params
   # {title: "블라블라"}
   get '/posts/create' do
   	@title = params[:title]
   end
   ```



##### ORM : object relational mapper

객체지향언어(ruby)와 데이터베이스(sqlite)를 연결하는 것을 도와주는 도구

[Datamapper]('http://recipes.sinatrarb.com/p/models/data_mapper')

##### 사전준비사항

`$ gem install datamapper`

`$ gem install dm-sqlite-adapter`

```ruby
# app.rb
# c9에서 json 라이브러리 충돌로 인한 코드
gem 'json', '~>1.6'
require 'datamapper'
#blog.db 세팅
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
# Post 객체(Obeject) 생성
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

# Post table 생성(Relational)
Post.auto_upgrade!
```

##### 데이터 조작

* 기본

  `Post.all`

* C(create)

  ```ruby
  # 첫번째 방법
  Post.create(title: "test", body: "test")
  # 두번째 방법
  p = Post.new
  p.title = "test"
  p.body = "test"
  p.save # db에 작성
  ```

* R(Read)

  ```ruby
  Post.get(1) # get(id)
  ```

* U(update)

  ```ruby
  # 첫번째
  Post.get(1).update(title: "test", body: "test")
  # 두번째
  p = Post.get(1)
  p.title = "제목"
  p.body = "내용"
  p.save
  ```

* D(Destroy)

  ```ruby
  Post.get(1).destroy
  ```



##### CRUD 만들기

Create : action이 두개 필요

```ruby
# 사용자에게 입력받는 창
get '/posts/new' do
end
# 실제로 db에 저장하는 곳
get 'posts/create' do
    Post.create(title: params[:title], body: params[:body])
end
```

Read : variable routing

```ruby
# app.rb 
get 'posts/:id' do
	@post = Post.get(params[:id])
end
```

