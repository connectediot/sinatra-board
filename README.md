### Sinatra 정리

#### 준비사항

필수 gem 설치

`$ gem install sinatra`

`$ gem install sinatra-reloader`

#### 시작 페이지 만들기(routing 설정 및 대응되는 view 설정)

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



#### 폴더 구조 

* app.rb
* views/
  * .erb
  * layout.erb

#### layout.erb

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



#### erb에서 루비 코드 활용하기

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
<%# "주석" %>

```

#### params 

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

* params를 확인하기 위해서 코드를 추가하자.

```ruby
    before do
    p "*****************"
    p params
    p request.path_info
    p request.fullpath
    p request.url
    p "*****************"
```


#### ORM : object relational mapper

객체지향언어(ruby)와 데이터베이스(sqlite)를 연결하는 것을 도와주는 도구

[Datamapper]('http://recipes.sinatrarb.com/p/models/data_mapper')

#### 사전준비사항

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

#### 데이터 조작

* 기본

  ```ruby
    Post.all
  ```

* C(create)
  > create는 두 가지 방법이 있음.
  > 1) Post.create로 클래스 메소드를 활용
  > 2) post = Post.new로 하나의 인스턴스를 만들어서 활용

  ```ruby
    2.4.0 :003 > Post.create(title: 111, body: 111)
    ~ (0.016058) INSERT INTO "posts" ("title", "body", "created_at") VALUES ('111', '111', '2018-06-11T07:05:41+00:00')
    => #<Post @id=1 @title="111" @body="111" @created_at=#<DateTime: 2018-06-11T07:05:41+00:00 ((2458281j,25541s,146636304n),+0s,2299161j)>> 
  ```

* R(Read)
  > Read는 특정한 하나를 가져오는 것(id - primary key)

  ```ruby
    2.4.0 :004 > Post.get(1)
     ~ (0.000316) SELECT "id", "title", "created_at" FROM "posts" WHERE "id" = 1 LIMIT 1
     => #<Post @id=1 @title="111" @body=<not loaded> @created_at=#<DateTime: 2018-06-11T07:05:41+00:00 ((2458281j,25541s,0n),+0s,2299161j)>> 
  ```

* U(update)
  > update 는 특정한 하나를 가져오고(id - primary key)
  > 이를 수정. 즉, create와 같이 2가지 방법이 있음.

  ```ruby
  # 첫번째
  2.4.0 :006 > Post.get(1).update(title: "222수정", body: "222수정")                               
  ~ (0.000222) SELECT "id", "title", "created_at" FROM "posts" WHERE "id" = 1 LIMIT 1
  ~ (0.000054) SELECT "id", "body" FROM "posts" WHERE "id" = 1 ORDER BY "id"
  ~ (0.015631) UPDATE "posts" SET "title" = '222수정', "body" = '222수정' WHERE "id" = 1
  => true 
  # 두번째
  p = Post.get(1)
  p.title = "제목"
  p.body = "내용"
  p.save
  ```

* D(Destroy)
  > destroy 는 특정한 하나를 가져오고(id - primary key) 삭제

  ```ruby
    2.4.0 :007 > Post.get(1).destroy
     ~ (0.000103) SELECT "id", "title", "created_at" FROM "posts" WHERE "id" = 1 LIMIT 1
     ~ (0.014962) DELETE FROM "posts" WHERE "id" = 1
     => true 
  ```



#### CRUD 만들기

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

#### bundler를 통한 gem 관리

> 어플리케이션의 의존성(dependency)를 관리 해주는 bundler

1. bundler 설치 

   `gem install bundler`

2. `Gemfile` 작성 : 루트 디렉토리에 만들기

   ```
   source "https://rubygems.org"
   gem 'sinatra'
   gem 'sinatra-reloader'
   gem 'datamapper'
   gem 'dm-sqlite-adapter'
   ```

   

3. `gem`설치
   `bundle install` 





## User CRUD

필수 : email, password

회원가입(C)

회원정보보기(R)



#### heroku 배포 

1. heroku에서 addon 추가
   `heroku postgre`

2. `Gemfile` 수정

   ```
   source "https://rubygems.org"
   gem 'sinatra'
   gem 'sinatra-reloader'
   gem 'datamapper'
   gem 'bcrypt'
   gem 'rack'
   gem 'json', '~> 1.6'
   group :production do
   	gem 'pg'
   	gem 'dm-postgre-adapter'
   end
   
   group :develeopment, :test do
   	gem 'dm-sqlite-adapter'
   end
   ```

   * pg를 쓰는 이유는 헤로쿠에서 지원하는 db이기 때문.
   * **`bundle install --without production`**

3. `model.rb` 파일에서 db 경로 수정

   ```ruby
   configure :development do
       DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")
   end
   
   configure :production do 
       DataMapper::setup(:default, ENV["DATABASE_URL"]) 
   end
   ```

   * ENV["DATABASE_URL"]은 heroku 서버에서 설정되어 있는 환경 변수.

4. `config.ru` 추가 -> **루트디렉토리에**

```ruby
require './app'
run Sinatra::Application
```

	* 헤로쿠에서 서버를 실행하는 방법이 rake를 활용하기 때문.

`$ ruby app.rb -o $IP`

`$ bundle exec rakeup config.ru -o $IP -p $PORT` 

5. console에서 헤로쿠로 push

   `$ heroku login`

   `$ git add . `

   `$ git commit -m "msg"`

   `$ git push heroku master`