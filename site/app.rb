require 'sinatra'
require 'slim'
require 'sqlite3'

before do
    session[:user] = 1
    result = []
end

get('/') do
    db = SQLite3::Database.new("db/db.db")
    db.results_as_hash = true
    result = db.execute("SELECT * FROM blogpost")
    slim(:setup,locals:{blogposts:result})
    
end

get('/content') do
    slim(:"content/index")
end

post('/blogpost/new') do
    user_id = session[:user]
    content = params["content"]
    db = SQLite3::Database.new("db/db.db")
    db.execute("INSERT INTO blogpost (content, user_id) VALUES (?,?)",content, user_id)

    redirect('/')
end

get('/user/index') do
   slim(:"user/index") 
end