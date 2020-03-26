require 'sinatra'
require 'slim'
require 'sqlite3'

before do
    # session[:user] = 1
    result = []
end

after do
    p session[:user]
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


# Fungerar inte.
# Efter att login lades till så slutade det fungera att lägga till content
post('/blogpost/new') do
    user_id = session[:user]
    content = params["content"]
    db = SQLite3::Database.new("db/db.db")
    db.execute("INSERT INTO blogpost (content, id) VALUES (?,?)",content,id)
    
    redirect('/')
end

get('/user/index') do
    slim(:"user/index") 
end


# Skapa konto, FUNGERAR DELVIS.
# Ingenting kollar om newPass == confPass
post('/user/skapaKonto') do
    newUsername = params['newUsername'] 
    newPassword = params['newPassword']
    confirmPassword = params['confirmPassword']
    
    
    db = SQLite3::Database.new("db/db.db")
    db.execute("INSERT INTO user (username, password) VALUES (?,?)",newUsername, newPassword)
    
    redirect('/')
end

# Fungerar inte delvis.
# Kollar ej om det är korrekt user med korrekt pass
post('/user/login') do
    loginUsername = params['username'] 
    loginPassword = params['password'] 
    
    
    db = SQLite3::Database.new("db/db.db")
    result = db.execute("SELECT password,id FROM user WHERE username = ?",loginUsername)
    
    p result
    p loginPassword
    if result[0][0] == loginPassword
        session[:user] = result[0][1]
    else
        p "fel"
    end
    redirect('/')
end

# Fungerar inte.
# Händer inget vid klick
post('/removeContent') do

    db = SQLite3::Database.new("db/db.db")
    db.execute("DELETE FROM blogpost WHERE content",item)

    redirect('/')
end
