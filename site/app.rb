require 'sinatra'
require 'slim'

before do
    session[:user] = 1
end

get('/') do
    slim(:setup)
    
end

get('/content') do
    slim(:"content/index")
end